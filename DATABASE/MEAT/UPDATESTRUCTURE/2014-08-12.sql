DO $$
  BEGIN
    PERFORM gpInsertUpdate_Object_BranchLink(0, Branch.ObjectCode, Branch.ValueData, Branch.Id, 0, '') FROM OBJECT AS Branch 
              WHERE DescId = zc_Object_Branch() AND Id NOT IN (
                             SELECT BranchLink_Branch.ChildObjectId 
                               FROM ObjectLink AS BranchLink_Branch 
                              WHERE BranchLink_Branch.descid = zc_ObjectLink_BranchLink_Branch()
              );
              
     UPDATE ObjectLink SET childobjectid = Object_BranchLink_View.Id
       FROM Object_BranchLink_View 
      WHERE Object_BranchLink_View.BranchId = childobjectid and DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch();

    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchLink_PaidKind(), id, zc_Enum_PaidKind_FirstForm()) from Object_BranchLink_View 
       WHERE lower(ValueData) LIKE '%киев%' AND PaidKindId IS NULL;              

    PERFORM gpInsertUpdate_Object_BranchLink(0, Object_BranchLink_View.ObjectCode, Object_BranchLink_View.ValueData, Object_BranchLink_View.BranchId, zc_Enum_PaidKind_SecondForm(), '') from Object_BranchLink_View 
        WHERE lower(ValueData) LIKE '%киев%' AND BranchId NOT IN(
                               SELECT BranchId from Object_BranchLink_View 
                               WHERE lower(ValueData) LIKE '%киев%' AND PaidKindId = zc_Enum_PaidKind_SecondForm());

     UPDATE ObjectLink SET childobjectid = D.Id
       FROM (
SELECT * FROM Object_BranchLink_View WHERE PaidKindId = 3 or PaidKindId IS NULL) AS D 
      WHERE D.BranchId = childobjectid and DescId = zc_ObjectLink_Partner1CLink_Branch();
  END;
$$;
