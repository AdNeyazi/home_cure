# frozen_string_literal: true

require "propshaft/compiler"
require "set"

module HomeCureLab
  # Rewrites CSS `@import` rules to Propshaft digested URLs so precompiled
  # fingerprinted files resolve in production (static file servers only expose
  # paths like /assets/styles/base-<digest>.css).
  class CssImportUrlsCompiler < Propshaft::Compiler
    IMPORT_PATTERN = /@import\s+(?:url\(\s*([^)]+?)\s*\)|"(.*?)"|'(.*?)')\s*([^;]*);/

    def compile(asset, input)
      input.gsub(IMPORT_PATTERN) do
        raw_path = ($1 || $2 || $3).to_s.strip
        tail = $4.to_s.strip
        raw_path = raw_path.gsub(/\A["']|["']\z/, "")

        if remote_or_data?(raw_path)
          next Regexp.last_match(0)
        end

        resolved = resolve_path(asset.logical_path.dirname, raw_path)
        if ref = load_path.find(resolved)
          suffix = tail.present? ? " #{tail}" : ""
          %(@import url("#{url_prefix}/#{ref.digested_path}")#{suffix};)
        else
          Propshaft.logger.warn(
            "Unable to resolve @import '#{raw_path}' -> '#{resolved}' in #{asset.logical_path}"
          )
          Regexp.last_match(0)
        end
      end
    end

    def referenced_by(asset, references: Set.new)
      asset.content.scan(IMPORT_PATTERN) do |g1, g2, g3, _tail|
        raw_path = (g1 || g2 || g3).to_s.strip.gsub(/\A["']|["']\z/, "")
        next if remote_or_data?(raw_path)

        resolved = resolve_path(asset.logical_path.dirname, raw_path)
        ref = load_path.find(resolved)
        next unless ref && references.exclude?(ref)

        references << ref
        references.merge referenced_by(ref, references: references)
      end

      references
    end

    private

    def remote_or_data?(path)
      path =~ %r{\A(?:https?:)?//}i || path.start_with?("data:")
    end

    def resolve_path(directory, filename)
      directory = Pathname.new(directory)
      if filename.start_with?("../")
        Pathname.new(directory + filename).relative_path_from("").to_s
      elsif filename.start_with?("/")
        filename.delete_prefix("/").to_s
      else
        (directory + filename.delete_prefix("./")).to_s
      end
    end
  end
end
