DO $$
   DECLARE vbAdmin integer;
BEGIN

delete from partner where kodbranch ='' and namebranch = ''  and juridicalname = '';

  vbAdmin :=  (SELECT 
         Object_User.Id
   FROM Object AS Object_User
   WHERE (Object_User.ValueData = 'Админ') AND (Object_User.DescId = zc_Object_User()));


PERFORM gpInsertUpdate_Object_StreetKind(0, 0, streettype, vbAdmin::TVarChar) 
  FROM   (
SELECT streettype
  FROM partner
GROUP BY streettype) AS streettype 
WHERE NOT (streettype.streettype IN ( SELECT Name FROM gpSelect_Object_StreetKind(''))) ;

PERFORM gpInsertUpdate_Object_CityKind(0, 0, streettype, vbAdmin::TVarChar) 
  FROM   (
SELECT streettype
  FROM partner
GROUP BY streettype) AS streettype 
WHERE NOT (streettype.streettype IN ( SELECT Name FROM gpSelect_Object_CityKind(''))) ;

PERFORM gpInsertUpdate_Object_Region(0, 0, region, vbAdmin::TVarChar) 
  FROM   (
SELECT upper(trim(region)) as region
  FROM partner
GROUP BY  upper(trim(region)) ) AS region 
WHERE NOT (region.region IN ( SELECT Name FROM gpSelect_Object_Region(''))) ;


PERFORM gpInsertUpdate_Object_City(0, 0, cityname, CityKind.Id, Region.Id, 0, vbAdmin::TVarChar)
 FROM 

(SELECT citytype, cityname, upper(trim(region)) AS Region


  FROM partner
 
WHERE cityname <> ''  
  
GROUP BY citytype, cityname, upper(trim(region))) AS partner

  
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Partner.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_Region('') AS Region ON Partner.Region = Region.Name
WHERE NOT (cityname, CityKind.Id , Region.Id)  IN (
SELECT Name, CityKindId, RegionId FROM gpSelect_Object_City('') ORDER BY Name);

PERFORM gpInsertUpdate_Object_Street(0, 0, streetname, '', StreetKind.Id, City.Id, 0, vbAdmin::TVarChar) 
FROM (SELECT trim(citytype) AS citytype
     , trim(cityname) AS cityname
     , trim(regiontype) AS regiontype
     , upper(trim(region)) AS region
     , trim(streettype) AS streettype
     , trim(streetname) AS streetname
  FROM partner WHERE streetname <> ''
group BY trim(citytype)
       , trim(cityname)
       , trim(regiontype)
       , upper(trim(region))
       , trim(streettype)
       , trim(streetname)
ORDER BY streetname) AS Street

  LEFT JOIN gpSelect_Object_Region('') AS Region ON Street.Region = Region.Name
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Street.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_City('') AS City ON Street.cityname = City.Name AND City.CityKindId = CityKind.Id
  LEFT JOIN gpSelect_Object_StreetKind('') AS StreetKind ON Street.StreetType = StreetKind.Name
  
WHERE NOT (streetname, StreetKind.Id, City.Id)  IN (
SELECT Name, StreetKindId, CityId FROM gpSelect_Object_Street('') ORDER BY Name);

UPDATE partner SET PartnerId = Object_Partner.Id

       FROM Object AS Object_Partner1CLink
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
             WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink()  AND partner.codett1c <> ''
       AND partner.codett1c::integer = Object_Partner1CLink.ObjectCode
                             AND zfGetBranchFromBranchCode(kodbranch::integer) = ObjectLink_Partner1CLink_Branch.ChildObjectId;



END $$;


--SELECT  codett1c, ttin1c, Object_Partner.Id, Object_Partner.valuedata
--  FROM partner
--            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = partner.PartnerId;