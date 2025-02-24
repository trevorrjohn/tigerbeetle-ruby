module SharedLib
  class << self
    def path
      prefix = ''
      linux_libc = ''
      suffix = ''

      arch, os = RUBY_PLATFORM.split('-')

      arch =
        case arch
        when 'x86_64', 'amd64' then 'x86_64'
        when 'aarch64', 'arm64' then 'aarch64'
        else
          raise "Unsupported architecture: #{arch}"
        end

      case os
      when 'darwin', 'darwin22'
        prefix = 'lib'
        system = 'macos'
        suffix = '.dylib'
      when 'linux'
        prefix = 'lib'
        system = 'linux'
        linux_libc = detect_libc
        suffix = '.so'
      when 'windows'
        system = 'windows'
        suffix = '.dll'
      else
        raise "Unsupported system: #{os}"
      end

      File.expand_path("./pkg/#{arch}-#{system}#{linux_libc}/#{prefix}tb_client#{suffix}", __dir__)
    end

    private

    def detect_libc
      if system('ldd --version 2>&1 | grep -q "musl"')
        '-musl'
      elsif system('ldd --version 2>&1 | grep -q "GNU"')
        '-gnu.2.27'
      else
        raise 'Unsupported libc'
      end
    end
  end
end
