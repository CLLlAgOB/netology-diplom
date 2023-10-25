{
  "components": {
    "nginxnetologyIngress": {
      "apiVersion": "networking.k8s.io/v1",
      "kind": "Ingress",
      "metadata": {
        "name": "nginxnetology-ingress",
        "namespace": "default",
        "annotations": {
          "ingress.alb.yc.io/group-name": "default",
          "ingress.alb.yc.io/subnets": "b0c2ohkdo7mos7c4q4td,e2l43ls9pjruvspkr0g4,e9b0lf0ujacgvpdbk3ph",
          "ingress.alb.yc.io/security-groups": "enpsf86dkkfbrcbeelmq",
          "ingress.alb.yc.io/external-ipv4-address": "auto",
          "ingress.alb.yc.io/prefix-rewrite": "/"
        }
      },
      "spec": {
        "tls": [
          {
            "hosts": ["prod.clllagob.ru"],
            "secretName": "yc-certmgr-cert-id-fpq1i7l3pgo0nvdc8ms3"
          }
        ],
        "rules": [
          {
            "host": "prod.clllagob.ru",
            "http": {
              "paths": [
                {
                  "pathType": "Prefix",
                  "path": "/myapp",
                  "backend": {
                    "service": {
                      "name": "nginxnetology-service",
                      "port": {
                        "name": "httpc"
                      }
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    },
    "grafanaIngress": {
      "apiVersion": "networking.k8s.io/v1",
      "kind": "Ingress",
      "metadata": {
        "name": "monitoring-ingress",
        "namespace": "monitoring",
        "annotations": {
          "ingress.alb.yc.io/group-name": "default",
          "ingress.alb.yc.io/subnets": "b0c2ohkdo7mos7c4q4td,e2l43ls9pjruvspkr0g4,e9b0lf0ujacgvpdbk3ph",
          "ingress.alb.yc.io/security-groups": "enpsf86dkkfbrcbeelmq",
          "ingress.alb.yc.io/external-ipv4-address": "auto",
          "ingress.alb.yc.io/prefix-rewrite": ""
        }
      },
      "spec": {
        "tls": [
          {
            "hosts": ["prod.clllagob.ru"],
            "secretName": "yc-certmgr-cert-id-fpq1i7l3pgo0nvdc8ms3"
          }
        ],
        "rules": [
          {
            "host": "prod.clllagob.ru",
            "http": {
              "paths": [
                {
                  "pathType": "Prefix",
                  "path": "/grafana",
                  "backend": {
                    "service": {
                      "name": "grafana",
                      "port": {
                        "name": "http"
                      }
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}
