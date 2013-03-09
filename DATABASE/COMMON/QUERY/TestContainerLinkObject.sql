select co1.containerId, co1.ObjectId as o, co2.ObjectID as o1, co3.ObjectId as o2 from
containerlinkobject co1,
containerlinkobject co2,
containerlinkobject co3
where co1.containerid = co2.containerid
and co1.containerid = co3.containerid
and co1.objectId < 2000
and co2.objectId <1800
and co3.ObjectId >1700