---
layout: docu
title: Keywords and Identifiers
redirect_from:
  - /docs/data/sql/case_sensitivity
---

## Identifiers

Similarly to other SQL dialects and programming languages, identifiers in DuckDB's SQL are subject to several rules.

* Unquoted identifiers need to conform to a number of rules:
    * They must not be a reserved keyword (see [`duckdb_keywords()`](duckdb_table_functions#duckdb_keywords)), e.g., `SELECT 123 AS SELECT` will fail.
    * They must not start with a number or special character, e.g., `SELECT 123 AS 1col` is invalid.
    * They cannot contain whitespaces (including tabs and newline characters).
* Identifiers can be quoted using double-quote characters (`"`). Quoted identifiers can use any keyword, whitespace or special character, e.g., `"SELECT"` and `" § 🦆 ¶ "` are valid identifiers.
* Quotes themselves can be escaped by repeating the quote character, e.g., to create an identifier named `IDENTIFIER "X"`, use `"IDENTIFIER ""X"""`.

## Database Names

Database names are subject to the rules for [identifiers](#identifiers).

Additionally, it is best practive to avoid DuckDB's two internal [database schema names](duckdb_table_functions#duckdb_databases), `system` and `temp`.
By default, persistent databases are named after their filename without the extension.
Therefore, the filenames `system.db` and `temp.db` (as well as `system.duckdb` and `temp.duckdb`) result in the database names `system` and `temp`, respectively.
If you need to attach to a database that has one of these names, use an alias, e.g.:

```sql
ATTACH 'temp.db' AS temp2;
USE temp2;
```

<!--
The list of internal schemas can be retrieved as follows:

```sql
SELECT database_name
FROM duckdb_databases()
WHERE internal = true;
```
```text
┌───────────────┐
│ database_name │
│    varchar    │
├───────────────┤
│ system        │
│ temp          │
└───────────────┘
```
-->

## Rules for Case-Sensitivity

### Keywords and Function Names

SQL keywords and function names are case-insensitive in DuckDB.

For example, the following two queries are equivalent:

```matlab
select COS(Pi()) as CosineOfPi;
SELECT cos(pi()) AS CosineOfPi;
```
```text
┌────────────┐
│ CosineOfPi │
│   double   │
├────────────┤
│       -1.0 │
└────────────┘
```

### Case-Sensitivity of Identifiers

Following the convention of the SQL standard, identifiers in DuckDB are case-insensitive.
However, each character's case (uppercase/lowercase) is maintained as originally specified by the user even if a query uses different cases when referring to the identifier.
For example:

```sql
CREATE TABLE tbl AS SELECT cos(pi()) AS CosineOfPi;
SELECT cosineofpi FROM tbl;
```
```text
┌────────────┐
│ CosineOfPi │
│   double   │
├────────────┤
│       -1.0 │
└────────────┘
```

To change this behavior, set the `preserve_identifier_case` [configuration option](configuration#configuration-reference) to `false`.

#### Handling Conflicts

In case of a conflict, when the same identifier is spelt with different cases, one will be selected randomly. For example:

```sql
CREATE TABLE t1 (idfield INT, x INT);
CREATE TABLE t2 (IdField INT, y INT);
SELECT * FROM t1 NATURAL JOIN t2;
```

```text
┌─────────┬───────┬───────┐
│ idfield │   x   │   y   │
│  int32  │ int32 │ int32 │
├─────────────────────────┤
│         0 rows          │
└─────────────────────────┘
```

#### Disabling Preserving Cases

With the `preserve_identifier_case` [configuration option](configuration#configuration-reference) set to `false`, all identifiers are turned into lowercase:

```sql
SET preserve_identifier_case = false;
CREATE TABLE tbl AS SELECT cos(pi()) AS CosineOfPi;
SELECT CosineOfPi FROM tbl;
```
```text
┌────────────┐
│ cosineofpi │
│   double   │
├────────────┤
│       -1.0 │
└────────────┘
```
