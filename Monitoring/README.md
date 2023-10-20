## Настройка мониторинга

Для настройки мониторинга была использована сборка kube-prometheus, взятая из [репозитория kube-prometheus](https://github.com/prometheus-operator/kube-prometheus).

### Измененные файлы:

- `grafana-config.yaml`
- `grafana-service.yaml`

Также был создан ингресс для доступа из интернета, расположенный по пути `netology-diplom\qbec\ingress\components\ingress.jsonnet`. В Grafana был добавлен шаблон 11074 - Node Exporter Dashboard EN 20201010-StarsL.cn.

### Шаги установки:

```shell
kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/
```

---

Пожалуйста, убедитесь, что все изменения и шаги корректно применены и соблюдены перед выполнением команд.