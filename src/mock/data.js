import { nanoid } from 'nanoid';

// HEAD DATA
export const headData = {
  title: 'Jóni Oliveira', // e.g: 'Name | Developer'
  lang: 'en', // e.g: en, es, fr, jp
  description: 'My website', // e.g: Welcome to my website
};

// HERO DATA
export const heroData = {
  title: '',
  name: 'Jóni Oliveira',
  subtitle: "I'm a Software Engineer intrestead in SRE/DevOps",
  cta: '',
};

// ABOUT DATA
export const aboutData = {
  img: 'me.jpg',
  paragraphOne:
    "I'm from Portugal, living in Leiria and currently working at xgeeks by KI Group as Backend Engineer but moving to SRE/DevOps",
  paragraphTwo:
    "I've started to work in IT in 2014. Initally focused on Android and Java, but my intrestead for services, initally, and deploying application makes me move from that in 2017",
  paragraphThree:
    'Graduated in Polytechnic Institute of Leiria and University of Coimbra. Loving to learn about tech and try to be a problem solver.',
  resume: '', // if no resume, the button will not show up
};

// PROJECTS DATA
export const projectsData = [
  {
    id: nanoid(),
    img: 'bucket.jpeg',
    title: 'Terraform website from bucket',
    info: 'Simple way to deploy a static website using a GCP bucket and terraforms',
    info2: '',
    repo: 'https://github.com/jonioliveira/tf-web-from-bucket', // if no repo, the button will not show up
  },
  {
    id: nanoid(),
    img: 'bconforto.jpeg',
    title: 'BConforto Android App',
    info: 'Android app to be used internally to define pricing for costumers',
    info2: 'BConforto is a furniture company focused on upholstery',
    repo: 'https://github.com/jonioliveira/BConforto', // if no repo, the button will not show up
  },
];

// PROJECTS DATA
export const postsData = [
  {
    id: nanoid(),
    img: 'suricata.jpeg',
    title: 'Sentry and Kubernetes',
    info: 'Take-aways from deploying Sentry in a k8s cluster',
    info2: '',
    url: 'https://medium.com/xgeeks/sentry-and-kubernetes-eabc507c96b7',
    repo: '', // if no repo, the button will not show up
  },
];

// CONTACT DATA
export const contactData = {
  cta: '',
  btn: '',
  email: 'joni.oliveira@gmail.com',
};

// FOOTER DATA
export const footerData = {
  networks: [
    {
      id: nanoid(),
      name: 'twitter',
      url: 'https://twitter.com/joniroliveira',
    },
    {
      id: nanoid(),
      name: 'medium',
      url: 'https://medium.com/@jonioliveira',
    },
    {
      id: nanoid(),
      name: 'linkedin',
      url: 'https://www.linkedin.com/in/jonioliveira',
    },
    {
      id: nanoid(),
      name: 'github',
      url: 'https://github.com/jonioliveira',
    },
  ],
};

// Github start/fork buttons
export const githubButtons = {
  isEnabled: true, // set to false to disable the GitHub stars/fork buttons
};
