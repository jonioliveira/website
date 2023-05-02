import Link from '@/components/Link'

const Experience = ({ title, company, location, range, url, text1, text2, text3, tech }) => {
  return (
    <div className="my-3">
      <div className="flex flex-row text-xl">
        <span className="text-gray-500 dark:text-gray-400">{title}</span>{' '}
        <span className="text-gray-500 dark:text-gray-400">&nbsp;@&nbsp;</span>{' '}
        <span className="text-primaryColor dark:text-primaryColorDark">
          <Link href={url} className="no-underline">
            {company}
          </Link>
        </span>
      </div>
      <div>
        <div className="p-1 font-mono text-sm text-gray-400 dark:text-gray-600">{range}</div>
        <div className="p-2">
          <div className="flex flex-row ">
            <div className="text-primaryColor dark:text-primaryColorDark mr-2 text-lg">
              {' '}
              &#8227;
            </div>
            <div className="text-gray-500 dark:text-gray-400">{text1}</div>
          </div>
          <div className="flex flex-row">
            <div className="text-primaryColor dark:text-primaryColorDark mr-2 text-lg">
              {' '}
              &#8227;
            </div>
            <div className="text-gray-500 dark:text-gray-400">{text2}</div>
          </div>
          <div className="items-top flex flex-row">
            <div className="text-primaryColor dark:text-primaryColorDark mr-2 text-lg">
              {' '}
              &#8227;
            </div>
            <div className="text-gray-500 dark:text-gray-400">{text3}</div>
          </div>
          <div className="items-top flex flex-row">
            <div className="text-primaryColor dark:text-primaryColorDark mr-2 text-lg">
              {' '}
              &#8227;
            </div>
            <div className="text-gray-500 dark:text-gray-400">
              <span className="font-bold">Used technologies:</span>
              {tech}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Experience
