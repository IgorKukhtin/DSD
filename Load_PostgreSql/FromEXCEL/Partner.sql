DO $$
   DECLARE vbAdmin integer;
BEGIN

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


PERFORM gpInsertUpdate_Object_City(0, 0, cityname, CityKind.Id, Region.Id, 0, , vbAdmin::TVarChar)
 FROM 

(SELECT citytype, cityname, upper(trim(region)) AS Region


  FROM partner
 
WHERE cityname <> ''  
  
GROUP BY citytype, cityname, upper(trim(region))) AS partner

  
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Partner.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_Region('') AS Region ON Partner.Region = Region.Name
WHERE NOT (cityname, CityKind.Id , Region.Id)  IN (
SELECT Name, CityKindId, RegionId FROM gpSelect_Object_City(''))


END $$;