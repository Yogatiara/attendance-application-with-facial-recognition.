import {
  collection,
  getDocs,
  getDoc,
  doc,
  deleteDoc,
} from "firebase/firestore";

import { db } from "./config/fireStore";

const getAllMonitoringData = async () => {
  const querySnapshot = await getDocs(collection(db, "monitoring"));
  const monitoringData = querySnapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
  return monitoringData;
};

const getSubMonitoringData = async (monitoringDocId) => {
  const querySnapshot = await getDocs(
    collection(db, "monitoring", monitoringDocId, "monitoring_detail"),
  );
  const monitoringData = querySnapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
  return monitoringData;
};

const getMonitoringDataById = async (monitoringDocId) => {
  const docRef = doc(db, "monitoring", monitoringDocId);
  const docSnap = await getDoc(docRef);

  return { id: docSnap.id, ...docSnap.data() };
};

const deleteMonitoringData = async (monitoringDocId) => {
  await deleteDoc(doc(db, "monitoring", monitoringDocId));
};

export {
  getAllMonitoringData,
  getSubMonitoringData,
  getMonitoringDataById,
  deleteMonitoringData,
};
