-- Function: gpGet_Object_Client_NEW_S()

DROP FUNCTION IF EXISTS gpGet_Object_Client_NEW_S ();

CREATE OR REPLACE FUNCTION gpGet_Object_Client_NEW_S()

RETURNS TABLE (
               ClientId Integer, ClientName TVarChar, Id_Postgres_client Integer, DatabaseId_Client Integer
             , DatabaseId_DiscClient Integer, DiscountKlientId Integer, DiscountKlientName TVarChar, DiscountTax TFloat, DiscountTaxTwo TFloat
             , PhoneMobile TVarChar, Phone TVarChar
             , UnitId Integer, Id_Postgres_Unit Integer, UnitName TVarChar, UsersName TVarChar, Id_Postgres_user Integer
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
            WITH tmp AS (select * from gpGet_Object_Client_NEW_S1 () AS RetV
                         UNION ALL
                          select * from gpGet_Object_Client_NEW_S2 () AS RetV
                         UNION ALL
                          select * from gpGet_Object_Client_NEW_S3 () AS RetV
                         )
            SELECT *
            FROM tmp
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.18                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Client_NEW_S () WHERE DiscountKlientName <> ClientName ORDER BY 2
-- SELECT * FROM gpGet_Object_Client_NEW_S () ORDER BY 2
/*
   select 
     Unit.Id as ClientId 
   , char(39) + Unit.UnitName + char(39) as ClientName
   , Unit.Id_Postgres as Id_Postgres_client
   , Unit.DatabaseId as DatabaseId_Client
   , DiscountKlient.DatabaseId  as DatabaseId_client
   , DiscountKlient.Id AS DiscountKlientId
   , char(39) + DiscountKlient.DiscountKlientName + char(39)  As DiscountKlientName
   , DiscountKlient.DiscountTax 
   , DiscountKlient.DiscountTaxTwo 
   , char(39) + DiscountKlient.PhoneMobile  + char(39) AS PhoneMobile
   , char(39) + DiscountKlient.Phone  + char(39) as Phone
   , Unit_find.Id as UnitId 
   , Unit_find.Id_Postgres  as Id_Postgres_Unit
   , Unit_find.UnitName as UnitName
   , Users.UsersName
   , Users.UserId_Postgres  as Id_Postgres_user
   from Unit inner join DiscountKlient on DiscountKlient.ClientId = Unit.id 
        left outer join Users on users.id = DiscountKlient.LastUserID 

      left outer join dba.Unit as Unit_find on Unit_find.Id = 
    case when Users.Id = 119 then 5727  --  // ??????? Savoy-P.Z.	Savoy_PZ1	801
         when Users.Id = 121 then 5727 --  // ??????? Savoy-P.Z.	Savoy_PZ2	801
         when Users.Id = 130 then 1121 --  // ??????? CHADO	???????? ?.?.	1761
         when Users.Id = 133 then 1121 --  // ??????? CHADO	??????????? ?.	9829
         when Users.Id = 152 then 969  --  // ??????? Terry-Vintage	?????????? ?.	2213
         when Users.Id = 143 then 234  --  // ??????? SAVOY	?????? ?.?.	8726
         when Users.Id = 139 then 978  --  // ??????? Vintag	??????? ?.	3146
         when Users.Id = 117 then 240  --  // ??????? 5 ???????	?????? ?.	5193
         when Users.Id = 140 then 29018  --  // ??????? Savoy-O	????????????? ?.	1294
         when Users.Id = 127 then 204  --  // ??????? Terri-Luxury	??????? ?.?.	2797
         when Users.Id = 157 then 11932  --  // ??????? Chado-Outlet	?????????? ?.	39
         when Users.Id = 153 then 969  --  // ??????? Terry-Vintage	???????? ?.	1438
         when Users.Id = 118 then 1121 --  // ??????? CHADO	??????????? ?.	6462
         when Users.Id = 142 then 29018  --  // ??????? Savoy-O	?????????? ?.	1249
         when Users.Id = 124 then 240  --  // ??????? 5 ???????	?????????? ?	6000
         when Users.Id = 132 then 240  --  // ??????? 5 ???????	????????? ?.	5349
         when Users.Id = 125 then 235  --  // ??????? MaxMara	??????????? ?.?.	5940
         when Users.Id = 155 then 969  --  // ??????? Terry-Vintage	???????? ?.	235
         when Users.Id = 134 then 240  --  // ??????? 5 ???????	????? ?.	1585
         when Users.Id = 131 then 1121 --  // ??????? CHADO	????????? ?.?.	6588
         when Users.Id = 150 then 29018  --  // ??????? Savoy-O	???????? ?.	80
         when Users.Id = 136 then 204  --  // ??????? Terri-Luxury	????????? ?.	10352
         when Users.Id = 151 then 969  --  // ??????? Terry-Vintage	????? ?.	2636
         when Users.Id = 9   then 235  --  // ??????? MaxMara	??????? ?.?.	125
         when Users.Id = 138 then 11772  --  // ??????? ?????-Out	??????? ?.	5856
         when Users.Id = 8   then 235  --  // ??????? MaxMara	??????? ?.?.	11311
         when Users.Id = 135 then 204  --  // ??????? Terri-Luxury	???????? ?.	5655
         when Users.Id = 156 then 204  --  // ??????? Terri-Luxury	???????? ?.	217
         when Users.Id = 154 then 11772  --  // ??????? ?????-Out	???????? ???	348
         when Users.Id = 116 then 234  --  // ??????? SAVOY	???????????? ?.	5128
         when Users.Id = 122 then 240  --  // ??????? 5 ???????	???????? ?	1778
         when Users.Id = 126 then 235  --  // ??????? MaxMara	???????? ?	66
         when Users.Id = 144 then 234  --  // ??????? SAVOY	????????? ?.?.	3978
         when Users.Id = 147 then 20484  --  // ??????? ESCADA	??????? ?	2867
         when Users.Id = 158 then 11932  --  // ??????? Chado-Outlet	?????? ?.	45
         when Users.Id = 123 then 240  --  // ??????? 5 ???????	????? ?.	1512
         when Users.Id = 128 then 204  --  // ??????? Terri-Luxury	?????? ?.?.	2470
         when Users.Id = 148 then 20484  --  // ??????? ESCADA	????????? ?.	1997
         when Users.Id = 149 then 234  --  // ??????? SAVOY	??????? ?.	72

         when Users.Id = 129 then 1121  --  // ????????? ?.?.

       end 

   where Unit.KindUnit = zc_kuClient() 
order by 2
*/
/*
 SELECT DiscountKlientName, Object.ValueData
    , PhoneMobile, ObjectString_PhoneMobile.ValueData
    , Phone, ObjectString_Phone.ValueData
    , DiscountTax, ObjectFloat_DiscountTax.ValueData
    , DiscountTaxTwo, ObjectFloat_DiscountTaxTwo.ValueData
    , case when UnitName <> '' then UnitName 
           when DatabaseId_Client = 1 then 'магазин MaxMara'
           when DatabaseId_Client = 2 then 'магазин Terri-Luxury'
           when DatabaseId_Client = 3 then 'магазин 5 Элемент'
           when DatabaseId_Client = 4 then 'магазин CHADO'
           when DatabaseId_Client = 5 then 'магазин SAVOY'
           when DatabaseId_Client = 6 then 'магазин Savoy-P.Z.'
           when DatabaseId_Client = 7 then 'магазин Терри-Out'
           when DatabaseId_Client = 8 then 'магазин Vintag'
           when DatabaseId_Client = 9 then 'магазин ESCADA'
           when DatabaseId_Client = 10 then 'магазин Savoy-O'
           when DatabaseId_Client = 11 then 'магазин Terry-Vintage'
           when DatabaseId_Client = 12 then 'магазин Chado-Outlet'
           else '???'
      end as calcUnitName
    , Object_Unit.ValueData
    , UsersName, Object_LastUser.ValueData
    , aaa.ClientId
    , *
 FROM gpGet_Object_Client_NEW_S () as aaa
      left join Object on Object.Id = aaa.Id_Postgres_client

            LEFT JOIN ObjectLink AS ObjectLink_Client_LastUser
                                 ON ObjectLink_Client_LastUser.ObjectId = Object.Id
                                AND ObjectLink_Client_LastUser.DescId = zc_ObjectLink_Client_LastUser()
            LEFT JOIN Object AS Object_LastUser ON Object_LastUser.Id = ObjectLink_Client_LastUser.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                 ON ObjectLink_User_Unit.ObjectId = Object_LastUser.Id
                                AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId


            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax 
                                  ON ObjectFloat_DiscountTax.ObjectId = Object.Id 
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo 
                                  ON ObjectFloat_DiscountTaxTwo.ObjectId = Object.Id
                                 AND ObjectFloat_DiscountTaxTwo.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()

            LEFT JOIN ObjectString AS  ObjectString_PhoneMobile 
                                   ON  ObjectString_PhoneMobile.ObjectId = Object.Id
                                  AND  ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS  ObjectString_Phone 
                                   ON  ObjectString_Phone.ObjectId =Object.Id
                                  AND  ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()
-- where ClientName <> DiscountKlientName

  where (trim (lower (DiscountKlientName)) <> trim (lower (Object.ValueData))
        or PhoneMobile <> coalesce (ObjectString_PhoneMobile.ValueData, '')
        or Phone <> coalesce (ObjectString_Phone.ValueData, '')
        or DiscountTax <> coalesce (ObjectFloat_DiscountTax.ValueData, 0)
        or DiscountTaxTwo <> coalesce (ObjectFloat_DiscountTaxTwo.ValueData, 0)
         )
--     and lower (Object.ValueData) like lower ('%сон%')
--     and lower (Object.ValueData) like lower ('%чубар%')

    ORDER BY 2, DiscountKlientName, aaa.ClientId
*/