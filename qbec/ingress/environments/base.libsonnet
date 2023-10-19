
// this file has the baseline default parameters
local base = {
  components: {
    phpmyadminIngress: {
      apiVersion: 'networking.k8s.io/v1',
      kind: 'Ingress',
      metadata: {
        name: 'phpmyadmin-ingress',
        annotations: {
          'ingress.alb.yc.io/group-name': 'default',
          'ingress.alb.yc.io/subnets': 'b0cq1jqbuh7idrdt48ei,e2lg5kvvvdpic3lvr2d2,e9bmj5cjvlqa02g5d6lc',
          'ingress.alb.yc.io/security-groups': 'enplctbb7prtimbuai6b',
          'ingress.alb.yc.io/external-ipv4-address': 'auto',
          'ingress.alb.yc.io/prefix-rewrite': '/',
        },
      },
      spec: {
        tls: [
          {
            hosts: ['clllagob.ru'],
            secretName: 'yc-certmgr-cert-id-fpqvf8gmglt0lu3shi7f',
          },
        ],
        rules: [
          {
            host: 'clllagob.ru',
            http: {
              paths: [
                {
                  pathType: 'Prefix',
                  path: '/phpmyadmin',
                  backend: {
                    service: {
                      name: 'phpmyadmin-service',
                      port: {
                        name: 'httpc',
                      },
                    },
                  },
                },
              ],
            },
          },
        ],
      },
    },
  },
};

base
