## Краткая инструкция по установке Ingress c ALB

### Полезные ссылки:
- Примеры от [Яндекс.Облака](https://github.com/yandex-cloud/examples/blob/master/tutorials/terraform/managed-kubernetes/k8s-and-registry-for-alb.tf).
- [Установка Ingress-контроллера Application Load Balancer](https://cloud.yandex.ru/docs/managed-kubernetes/operations/applications/alb-ingress-controller).
- Неофициальные инструкции [Телеграф](https://teletype.in/@cameda/3n75CiuRGB-?ysclid=lmwhr2k5hk738596468).
- Неофициальные инструкции [Телеграф](https://teletype.in/@cameda/NGvCl3lZrgB).

### Шаги по установке:

1. **Получаем список каталогов кластера:**

    ```shell
    yc resource folder list
    ```
   
2. **Смотрим имя кластера k8s:**

    ```shell
    yc managed-kubernetes cluster list --folder-id <идентификатор_папки>
    ```

3. **Получаем конфиг для внешнего подключения к Kubernetes:**

    ```shell
    yc managed-kubernetes cluster get-credentials <имя_кластера> --external --folder-id <идентификатор_папки>
    ```

4. **Проверяем доступность кластера:**

    ```shell
    kubectl cluster-info 
    ```

5. **Официальный скрипт установки ALB Ingress Controller от Яндекса:**

    ```shell
    export HELM_EXPERIMENTAL_OCI=1 && \
    cat key.json | helm registry login cr.yandex --username 'json_key' --password-stdin && \
    helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress/yc-alb-ingress-controller-chart \
      --version v0.1.22 \
      --untar && \
    helm install \
      --namespace alb \
      --create-namespace \
      --set folderId=<идентификатор_папки> \
      --set clusterId=<идентификатор_кластера> \
      --set-file saKeySecretKey=key.json \
      yc-alb-ingress-controller ./yc-alb-ingress-controller-chart/ && \
      rm -r yc-alb-ingress-controller-chart
    ```

6. **Разворачиваем структуру с помощью qbec в формате jsonnet:**

    Путь к файлу ingress.jsonnet:
    ```
    netology-diplom\qbec\ingress\components\ingress.jsonnet
    ```

    Необходимо указать правильно все id требуемых ресурсов в файле ingress.jsonnet.

    ```jsonnet
    "ingress.alb.yc.io/subnets": "b0c2ohkdo7mos7c4q4td,e2l43ls9pjruvspkr0g4,e9b0lf0ujacgvpdbk3ph",
    "ingress.alb.yc.io/security-groups": "enpsf86dkkfbrcbeelmq",
    ```
    `ingress.alb.yc.io/subnets` - подсети, на которых могут работать ноды.
    `ingress.alb.yc.io/security-groups` - указать по умолчанию (обязательно именно ID) либо создать новую с вашими правилами.

    Затем запустите:

    ```shell
    aleksandr@R2D2:/netology-diplom/qbec/ingress$ qbec apply default
    ```

    После запуска на кластере будет создаваться балансировщик, это займет продолжительное время.

---

Пожалуйста, убедитесь, что все идентификаторы и ключи заменены на действительные значения перед выполнением команд.