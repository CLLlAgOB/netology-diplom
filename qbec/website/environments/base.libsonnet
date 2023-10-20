
// this file has the baseline default parameters
{
  components: {
    website: {
      name: 'nginxnetology',
      image: 'clllagob/nginxnetology:latest',
      replicas: 1,
      containerPort: 80,
      servicePort: 80,
      nodeSelector: {},
      tolerations: [],
      ingressClass: 'nginx',
      domain: 'clllagob.ru',
    },
  },
}
