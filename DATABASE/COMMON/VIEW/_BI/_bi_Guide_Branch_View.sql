-- View: _bi_Guide_Branch_View

 DROP VIEW IF EXISTS _bi_Guide_Branch_View;

-- ���������� �������
CREATE OR REPLACE VIEW _bi_Guide_Branch_View
AS
       SELECT
             Object_Branch.Id         AS Id
           , Object_Branch.ObjectCode AS Code
           , Object_Branch.ValueData  AS Name
           --������ ���������
           , Object_Branch.AccessKeyId
           -- ������� "������ ��/���"
           , Object_Branch.isErased   AS isErased
           --����� ������� � ���������
           , ObjectString_InvNumber.ValueData  AS InvNumber
           --���� ���������
           , ObjectString_PlaceOf.ValueData    AS PlaceOf
           --��������� (���������)
           , Object_Personal.Id         AS PersonalId
           , Object_Personal.ValueData  AS PersonalName 
           --��������� (�������)
           , Object_PersonalStore.Id         AS PersonalStoreId
           , Object_PersonalStore.ValueData  AS PersonalStoreName
           --��������� (���������)
           , Object_PersonalBookkeeper.Id         AS PersonalBookkeeperId
           , Object_PersonalBookkeeper.ValueData  AS PersonalBookkeeperName
           --��������� (���������) ���������
           , ObjectString_PersonalBookkeeper.ValueData ::TVarChar AS PersonalBookkeeper_sign
           --��������
           , Object_PersonalDriver.Id         AS PersonalDriverId
           , Object_PersonalDriver.ValueData  AS PersonalDriverName 
           --��������/����������
           , Object_Member1.Id                AS Member1Id
           , Object_Member1.ValueData         AS Member1Name 
           --���������
           , Object_Member2.Id                AS Member2Id
           , Object_Member2.ValueData         AS Member2Name 
           --������������� ����(������ ��������)
           , Object_Member3.Id                AS Member3Id
           , Object_Member3.ValueData         AS Member3Name 
           --������������� ����(����)
           , Object_Member4.Id                AS Member4Id
           , Object_Member4.ValueData         AS Member4Name 
           --������������� (�������� �����)
           , Object_Unit.Id         AS UnitId
           , Object_Unit.ValueData  AS UnitName
           --������������� (����� ���������)
           , Object_UnitReturn.Id         AS UnitReturnId
           , Object_UnitReturn.ValueData  AS UnitReturnName
           --�������� ��������� �� �����
           , COALESCE (ObjectBoolean_Medoc.ValueData, False)      AS IsMedoc
           --���������� ���� ������ ���
           , COALESCE (ObjectBoolean_PartionDoc.ValueData, False) AS IsPartionDoc

       FROM Object AS Object_Branch
        --����� ������� � ���������
        LEFT JOIN ObjectString AS ObjectString_InvNumber
                               ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                              AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()       
        --���� ���������
        LEFT JOIN ObjectString AS ObjectString_PlaceOf
                               ON ObjectString_PlaceOf.ObjectId = Object_Branch.Id
                              AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()       
        --��������� (���������) ���������
        LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                               ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                              AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()   
        --�������� ��������� �� �����                      
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Medoc
                                ON ObjectBoolean_Medoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_Medoc.DescId = zc_ObjectBoolean_Branch_Medoc()    
        --���������� ���� ������ ���            
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                ON ObjectBoolean_PartionDoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc() 
        --��������� (���������)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                             ON ObjectLink_Branch_Personal.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
        LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Branch_Personal.ChildObjectId     
        --��������� (�������)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                             ON ObjectLink_Branch_PersonalStore.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
        LEFT JOIN Object AS  Object_PersonalStore ON Object_PersonalStore.Id = ObjectLink_Branch_PersonalStore.ChildObjectId  
        --��������� (���������)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                             ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
        LEFT JOIN Object AS Object_PersonalBookkeeper ON Object_PersonalBookkeeper.Id = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
        --��������
        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalDriver
                             ON ObjectLink_Branch_PersonalDriver.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalDriver.DescId = zc_ObjectLink_Branch_PersonalDriver()
        LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Branch_PersonalDriver.ChildObjectId
        -- 	��������/����������
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member1
                             ON ObjectLink_Branch_Member1.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member1.DescId = zc_ObjectLink_Branch_Member1()
        LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = ObjectLink_Branch_Member1.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member2
                             ON ObjectLink_Branch_Member2.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member2.DescId = zc_ObjectLink_Branch_Member2()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_Branch_Member2.ChildObjectId
        --������������� ����(������ ��������)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member3
                             ON ObjectLink_Branch_Member3.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member3.DescId = zc_ObjectLink_Branch_Member3()
        LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = ObjectLink_Branch_Member3.ChildObjectId
        --������������� ����(����)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member4
                             ON ObjectLink_Branch_Member4.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member4.DescId = zc_ObjectLink_Branch_Member4()
        LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = ObjectLink_Branch_Member4.ChildObjectId
        --������������� (�������� �����)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Unit
                             ON ObjectLink_Branch_Unit.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Unit.DescId = zc_ObjectLink_Branch_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Branch_Unit.ChildObjectId
        --������������� (����� ���������)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_UnitReturn
                             ON ObjectLink_Branch_UnitReturn.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_UnitReturn.DescId = zc_ObjectLink_Branch_UnitReturn()
        LEFT JOIN Object AS Object_UnitReturn ON Object_UnitReturn.Id = ObjectLink_Branch_UnitReturn.ChildObjectId
 
       WHERE Object_Branch.DescId = zc_Object_Branch()
      ;

ALTER TABLE _bi_Guide_Branch_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.25         * all
 09.05.25                                        *
*/

-- ����
--  SELECT * FROM _bi_Guide_Branch_View  limit 10
