require 'helper'

class TestDistro < Minitest::Test

  module Gem2Rpm::Template
    define_method(:default_location) { File.join(File.dirname(__FILE__), 'templates', 'fake_files') }
  end

  def test_get_template_for_unavailable_version
    assert_nil Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 16)
    assert_nil Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 0)
  end

  def test_get_template_for_available_version
    assert Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 17)
    assert Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 177)
  end

  def test_nature_for_unavailable_template
    class << Gem2Rpm::Distro
      define_method(:release_files) { [File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release15')] }
    end

    assert "fedora", Gem2Rpm::Distro.nature.to_s
  end

  def test_nature_for_available_template
    class << Gem2Rpm::Distro
      define_method(:release_files) { [File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release17')] }
    end

    assert "fedora-17-rawhide", Gem2Rpm::Distro.nature.to_s
  end

  def test_nature_for_two_release_files
    class << Gem2Rpm::Distro
      define_method(:release_files) { [File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release15'), File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release17')] }
    end

    assert "fedora", Gem2Rpm::Distro.nature.to_s
  end

end
