---
layout: docu
title: Excel Extension
---

This extension, contrary to its name, does not provide support for reading Excel files. It instead provides a function that wraps the number formatting functionality of the i18npool library, which formats numbers per Excel's formatting rules.

Excel files can be handled through the [`spatial` extension](spatial): see the [Excel Import](../guides/import/excel_import) and [Excel Export](../guides/import/excel_export) pages for instructions.

## Functions

| Function | Description | Example | Result |
|:--|:---|:--|:-|
| `text(`*`number`*`, `*`format_string`*`)`       | Format the given `number` per the rules given in the `format_string` | `text(1234567.897, 'h AM/PM')`    | `9 PM`    |
| `excel_text(`*`number`*`, `*`format_string`*`)` | Alias for `text`.                                                    | `text(1234567.897, 'h:mm AM/PM')` | `9:31 PM` |
