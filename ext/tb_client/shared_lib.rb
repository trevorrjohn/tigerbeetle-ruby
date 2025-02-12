module SharedLib
  def self.path
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
      suffix = '.so'
    when 'windows'
      system = 'windows'
      suffix = '.dll'
    else
      raise "Unsupported system: #{os}"
    end

    File.expand_path("./pkg/#{arch}-#{system}#{linux_libc}/#{prefix}tb_client#{suffix}", __dir__)
  end
end
