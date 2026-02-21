class Razin < Formula
  include Language::Python::Virtualenv

  desc "Static analysis scanner for SKILL.md-defined agent skills"
  homepage "https://github.com/theinfosecguy/razin"
  url "https://files.pythonhosted.org/packages/5e/82/46d0ded28edf107e309393e44ca42a21f3ef8684d137ac75d0d54a2a977e/razin-1.3.1.tar.gz"
  sha256 "cb7862da370e607cf2c04fd1e0d663d463df89752d8b1423c5489031bd77b792"
  license "MIT"

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    skill_dir = testpath/"sample"
    skill_dir.mkpath
    (skill_dir/"SKILL.md").write <<~MARKDOWN
      ---
      name: sample-skill
      ---
      # Sample
      command: run-this
    MARKDOWN

    shell_output("#{bin}/razin --version")
    system bin/"razin", "scan", "-r", testpath.to_s, "-o", (testpath/"output").to_s, "--no-stdout"
    assert_path_exists testpath/"output"/"sample-skill"/"summary.json"
  end
end
