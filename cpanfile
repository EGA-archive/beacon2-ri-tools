# No specific version needed #

# Modules for <Beacon2>
requires 'JSON::XS';                # To deal with JSON files
requires 'Path::Tiny';              # For I/O
requires 'Term::ANSIColor'          # To provide colors to STDOU
requires 'YAML::XS'                 # To deal with YAML files
requires 'PerlIO::gzip'             # For gzip operations
requires 'Data::Structure::Util';   # Miscellanea utils for data structures

# Additional modules for <Beacon2/utils>
requires 'Mojolicious';             # bff-api
requires 'MongoDB';                 # bff-api
requires 'Minion';                  # bff-queur
requires 'Minion::Backend::SQLite'; # bff-queue
requires 'File::Which';             # bff-validator
requires 'JSON::Validator';         # bff-validator
requires 'List::MoreUtils';         # bff-validator
requires 'Text::CSV_XS';            # bff-validator
requires 'Text::Unidecode';         # bff-validator
