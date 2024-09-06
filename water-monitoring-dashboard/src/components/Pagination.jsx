import PropTypes from "prop-types";
import { Link } from "react-router-dom";
export const Pagination = ({
  prefPage,
  numbers,
  changeCpage,
  curentPage,
  nextPage,
}) => {
  return (
    <nav
      aria-label="Page navigation example"
      className="mt-6 flex flex-row justify-center text-base"
    >
      <ul className="inline-flex -space-x-px rounded-lg shadow-sm">
        <li>
          <Link
            onClick={prefPage}
            className="ms-0 flex h-8 items-center justify-center rounded-s-lg border border-e-0 border-[#5daeff] bg-white px-3 leading-tight text-[#5daeff] hover:bg-[#5daeff] hover:text-white"
          >
            Previous
          </Link>
        </li>

        {numbers.map((data, i) => (
          <li key={i}>
            <Link
              onClick={() => changeCpage(data)}
              className={`flex ${
                curentPage === data
                  ? "bg-[#5daeff] text-white"
                  : "bg-white text-[#5daeff]"
              } h-8 items-center justify-center border border-[#5daeff] px-3 leading-tight hover:bg-[#5daeff] hover:text-white`}
            >
              {data}
            </Link>
          </li>
        ))}

        <li>
          <Link
            onClick={nextPage}
            className="flex h-8 items-center justify-center rounded-e-lg border border-[#5daeff] bg-white px-3 leading-tight text-[#5daeff] hover:bg-[#5daeff] hover:text-white"
          >
            Next
          </Link>
        </li>
      </ul>
    </nav>
  );
};
Pagination.propTypes = {
  prefPage: PropTypes.func.isRequired,
  numbers: PropTypes.arrayOf(PropTypes.number).isRequired,
  changeCpage: PropTypes.func.isRequired,
  curentPage: PropTypes.number.isRequired,
  nextPage: PropTypes.func.isRequired,
};
