import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { IoReturnDownBack } from "react-icons/io5";

import { MonitoringDetailTable } from "./components/MonitoringDetailTable";

import {
  MonitoringDateCard,
  PHCard,
  TDSCard,
  TemperatureCard,
  TurbidityCard,
  WaterStatusCard,
} from "@water-monitoring-detail-components/cards";

// import subMonitoringData from "../../../data_dummy/monitoring.json";
// import subMonitoringData1 from "../../../data_dummy/monitoring1.json";

import {
  getMonitoringDataById,
  // getSubMonitoringData,
} from "../../../api/fetching";
import { Loading } from "@public-components/Loading";
import { Pagination } from "../../../components";

export const WaterMonitoringDetail = () => {
  const [monitoringData, setMonitoringData] = useState(null);
  const [subMonitoringData, setSubMonitoringData] = useState(null);
  const [curentPage, setCurrentPage] = useState(1);

  const [loading, setLoading] = useState(true);

  const { id } = useParams();

  useEffect(() => {
    const fetchMonitoringData = () => {
      return getMonitoringDataById(id)
        .then((res) => {
          setMonitoringData(res);
        })
        .catch((err) => {
          throw new Error(err);
        });
    };

    const fetchSubMonitoringData = async () => {
      // return getSubMonitoringData(id)
      //   .then((res) => {
      //     // setSubMonitoringData(res);
      //   })
      //   .catch((err) => {
      //     throw new Error(err);
      //   });
      try {
        if (id === "oo1fOWnhE5utVfzt4C2I") {
          const data = await import("../../../data_dummy/monitoring1.json");
          setSubMonitoringData(data.default);
        } else {
          const data = await import("../../../data_dummy/monitoring.json");
          setSubMonitoringData(data.default);
        }
      } catch (err) {
        console.error(err);
      }
    };

    const fetchAllData = async () => {
      setLoading(true);
      try {
        await Promise.all([fetchMonitoringData(), fetchSubMonitoringData()]);
      } catch (error) {
        console.error(error);
      } finally {
        setLoading(false);
      }
    };

    fetchAllData();
  }, [id]);

  const recordsPerPage = 20;
  let records;
  let numbers;

  if (subMonitoringData) {
    const lastIndex = curentPage * recordsPerPage;
    const firstIndex = lastIndex - recordsPerPage;
    records = subMonitoringData.slice(firstIndex, lastIndex);
    const npage = Math.ceil(subMonitoringData.length / recordsPerPage);
    numbers = [...Array(npage + 1).keys()].slice(1);
  }

  const prefPage = () => {
    if (curentPage !== 1) {
      setCurrentPage(curentPage - 1);
    }
  };

  const nextPage = () => {
    if (curentPage !== numbers.length) {
      setCurrentPage(curentPage + 1);
    }
  };

  const changeCpage = (i) => {
    setCurrentPage(i);
  };

  return (
    <>
      <div className="mt-12">
        {loading ? (
          <div className="z-50 h-screen w-full bg-blue-100 px-[580px] py-52">
            <Loading />
          </div>
        ) : (
          <>
            <Link
              to={"/water-monitoring"}
              className="flex w-24 items-center gap-3 text-2xl hover:underline"
            >
              <IoReturnDownBack className="text-3xl" />
              Back
            </Link>
            <div className="mt-6 flex place-content-center items-center gap-16 rounded-2xl">
              <div className="flex flex-col items-center gap-10 border-r-2 border-r-gray-400 pr-16">
                <MonitoringDateCard monitoringData={monitoringData} />

                <WaterStatusCard monitoringData={monitoringData} />
              </div>
              <div className="grid w-max grid-cols-2 place-content-center gap-5">
                <PHCard monitoringData={monitoringData} />
                <TurbidityCard monitoringData={monitoringData} />
                <TemperatureCard monitoringData={monitoringData} />
                <TDSCard monitoringData={monitoringData} />
              </div>
            </div>
            <div className="mx-16 mt-32">
              <MonitoringDetailTable
                // subMonitoringData={subMonitoringData}
                records={records}
              />
            </div>
            <div>
              <Pagination
                prefPage={prefPage}
                numbers={numbers}
                changeCpage={changeCpage}
                curentPage={curentPage}
                nextPage={nextPage}
              />
            </div>
          </>
        )}
      </div>
    </>
  );
};
