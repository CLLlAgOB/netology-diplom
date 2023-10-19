
// this file has the baseline default parameters
{
  components: {
    website: {
      name: 'nginxnetology',
      image: 'clllagob/nginxnetology:v0.1',
      replicas: 1,
      containerPort: 80,
      servicePort: 30081,
      nodeSelector: {},
      tolerations: [],
      ingressClass: 'nginx',
      domain: 'clllagob.ru',
    },
  },
}
