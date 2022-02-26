"""{{friendly_name}}."""
try:
    from importlib.metadata import version  # type: ignore
except ImportError:  # pragma: no cover
    from importlib_metadata import version  # type: ignore


try:
    __version__ = version(__name__)
except BaseException:  # pragma: no cover
    __version__ = "0.0.1"

__component__ = "{{package_name}}"
