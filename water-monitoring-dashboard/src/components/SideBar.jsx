import PropTypes from "prop-types";
import { IoWaterSharp } from "react-icons/io5";
// import { FaHome } from "react-icons/fa";
import { MdOutlineHistory } from "react-icons/md";

import logoDTS from "/Logo TDS.png";
import { DateTime } from "./DateTime";

export const SideBar = ({ NavLink }) => {
  return (
    <div className="fixed content-center">
      <ul className="h-[850px] w-80 rounded-2xl bg-slate-100 text-base-content">
        <div className="flex place-content-center pt-6">
          <img src={logoDTS} alt="logo TDS" className="w-56" />
        </div>
        <div className="mx-5 mt-16 flex place-content-center rounded-2xl border-2 bg-slate-100 p-4">
          <DateTime />
        </div>
        <ul className="menu mx-5 mt-2 space-y-6 rounded-2xl border-2 p-3 py-4">
          {/* <li>
            <NavLink to="/" className="hover:bg-blue-100">
              <FaHome className="text-3xl text-amber-950" />
              <span className="text-xl font-normal">Home</span>
            </NavLink>
          </li> */}
          <li>
            <NavLink to="/water-monitoring" className="hover:bg-blue-100">
              <IoWaterSharp className="text-3xl text-blue-600" />
              <span className="text-xl font-normal">Water Monitoring</span>
            </NavLink>
          </li>
          <li>
            <NavLink to="/history" className="hover:bg-blue-100">
              <MdOutlineHistory className="text-3xl text-black" />
              <span className="text-xl font-normal">History</span>
            </NavLink>
          </li>
        </ul>
      </ul>
    </div>
  );
};

SideBar.propTypes = {
  NavLink: PropTypes.elementType.isRequired,
};
