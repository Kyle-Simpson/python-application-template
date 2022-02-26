"""Test suite for the ``{{package_name}}.cli.console`` module."""
import pytest
from click.testing import CliRunner

from {{package_name}}.cli import console


@pytest.mark.unit
class TestConsoleMain:
    """Test cases for the ``console.main`` function."""

    @pytest.fixture(scope="class")
    def runner(self) -> CliRunner:
        """Return a CliRunner fixture."""
        return CliRunner()

    def test_main_succeeds(self, runner: CliRunner) -> None:
        """Console starts and stops."""
        result = runner.invoke(console.main)
        assert result.exit_code == 0
