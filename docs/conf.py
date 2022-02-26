"""Sphinx configuration."""

project = "{{package_name}}"
author = "{{author}}"
email = "{{author_email}}"
copyright = ""
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx_autodoc_typehints",
    "sphinx.ext.intersphinx",
    "sphinx.ext.todo",
    "sphinx.ext.mathjax",
    "sphinx.ext.ifconfig",
    "sphinx.ext.viewcode",
    "sphinx_click",
]
html_theme = "sphinx_rtd_theme"
