import Link from '@/components/Link'

const Experience = ({ title, university, location, range, url, text1, text2 }) => {
  return (
    <div className="my-3">
      <div className="flex flex-row text-xl">
        <span className="text-gray-500 dark:text-gray-400">{title}</span>{' '}
        <span className="text-gray-500 dark:text-gray-400">&nbsp;@&nbsp;</span>{' '}
        <span className="text-primaryColor dark:text-primaryColorDark">
          <Link href={url} className="no-underline">
            {university}
          </Link>
        </span>
      </div>
      <div>
        <div className="p-1 font-mono text-sm text-gray-400 dark:text-gray-600">{range}</div>
        <div className="p-1 font-mono text-sm text-gray-400 dark:text-gray-600">{location}</div>
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
        </div>
      </div>
    </div>
  )
}

export default Experience
