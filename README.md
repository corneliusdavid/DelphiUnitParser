# DelphiUnitParser

This little Delphi program looks through the `uses` clause of a Delphi project (.dpr) and lists all the units found. It supports an "ignore list" so you can see just the custom units you've added. It will soon be expanded to drill down to all the units listed and find additional units used recursively throughout the entire project.

## Why another unit parser? ##

There are other unit listers/parsers (for example, [GExperts' Project Dependencies](http://www.gexperts.org/tour/project_dependencies.html)), so why this one?

There are a couple of reasons:

1. I want all the units used in the entire project to be explicitly listed in the project file. There are some utilities (like [GExpert's Backup Project](http://www.gexperts.org/tour/backup_project.html)) that look only through those units.
2. I want to add functionality to make copies of an entire project and all units it uses into a separate folder so it can be easily migrated or used for other purposes without orphaned units.
