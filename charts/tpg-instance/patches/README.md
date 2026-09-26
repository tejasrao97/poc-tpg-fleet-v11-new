# Instance patch files

tpg-patch patches running Postgres instances with files in this folder, and
tpg-create-instance applies them to new instances when they are first rendered. The
chart reads them itself (`.Files.Get`), so they must live inside the chart; the
instance entry in `clusters/fleet.yaml` references them, relative to
`charts/tpg-instance/`:

```yaml
clusters:
  aks-tpg-poc-01:
    instances:
      orders-db:
        patches:
          postgres: [patches/example-postgres-resources.yaml]   # postgresPatchFilePath
          values: [patches/example-values-backup.yaml]          # valuesPatchFilePath
```

| Kind of file | Input and clusterMap key | Content | Applied |
|---|---|---|---|
| Postgres patch | `postgresPatchFilePath` | `kind: Postgres` and a `spec` fragment; any field of the Postgres CRD | merged into the rendered Postgres `spec` |
| Values patch | `valuesPatchFilePath` | a fragment of the chart values (`values.yaml` keys) | merged into the values before the chart renders |

Files are merged in list order: maps key by key, any other value (including
`false`, `0` and `""`) replaces the earlier one, a list replaces the whole list,
and `null` removes a key. tpg-patch refuses fields that another workflow owns,
fields that cannot change on a running instance, and fields the `tpg-instances`
ApplicationSet ignores (`backup.additionalParameters`, `backup.enableSSL`,
`backup.forcePathStyle`); see `docs/workflow-commands.md`, tpg-patch. The Service
fields of the Postgres spec (`serviceType`, `serviceAnnotations`,
`readOnlyServiceType`, `readOnlyServiceAnnotations`) come from the exposure
values, so a Postgres patch may not set them: change the exposure with a values
patch, for example `instance: {exposure: internalLoadBalancer}`. The old value
`instance.serviceType` is refused (replaced by `instance.exposure`).
tpg-create-instance applies its own creation rules (sizes and the storage class
may be set there); see `docs/workflow-commands.md`, tpg-create-instance. Commit
and push a file before a run references it.

Operator patch files live in `patches/operator/` at the repository root.
