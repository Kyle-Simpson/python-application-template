"""{{cookiecutter.friendly_name}} Console Application."""
import click

from {{package_name}} import __component__


@click.command()
@click.option(
    "--some-option",
    type=str,
    default="an option",
    help="A helpful option."
)
@click.pass_context
def main(
    ctx: click.Context,
    some_option: str,
) -> None:
    """Print something to console and emit a metric."""
    # use click.echo to print to the console for a human user
    click.echo(f"Starting {__component__} console initialization...")

    # Do stuff in here

    click.echo(f"{__component__} console initialization complete.")
