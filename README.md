# cookiecutter-memote

A cookiecuttter template for memote model repositories.

The best way to make use of this is to [install memote](https://github.com/biosustain/memote) and run:
```
memote new
```

## Configuration Values

| Configuration Key | Explanation                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------|
| `full_name`       | The full name of the main author or maintainer of the model.                                         |
| `email`           | A contact address for said maintainer.                                                               |
| `github_username` | The GitHub username of the maintainer. This will be used for automatic deployment as well.           |
| `project_name`    | Title for the model repository.                                                                      |
| `project_slug`    | Name for the directory and repository.                                                               |
| `model`           | An absolute path to an SBML file or 'default' which adds the *E. coli* core model to the repository. |
