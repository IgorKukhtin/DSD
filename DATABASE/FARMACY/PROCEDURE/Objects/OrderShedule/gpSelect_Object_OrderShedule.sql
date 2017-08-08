-- Function: gpSelect_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderShedule(Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_OrderShedule(Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderShedule(
    IN inUnitId      Integer,  -- �������������
    IN inJuridicalId Integer,  -- ��. ����
    IN inShowErased  Boolean,  -- �������� ��������� ��/���
    IN inisShowAll   Boolean,  -- �������� ��� �����
    IN inSession     TVarChar  -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer,
               Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, 
               Value5 TFloat, Value6 TFloat, Value7 TFloat,
               OurJuridicalName TVarChar,
               UnitId Integer, UnitName TVarChar,
               ProvinceCityId Integer, ProvinceCityName TVarChar,
               JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               isErased boolean,
               Inf_Text1 TVarChar, Inf_Text2 TVarChar,
               Color_Calc1 Integer, Color_Calc2 Integer, Color_Calc3 Integer, Color_Calc4 Integer,
               Color_Calc5 Integer, Color_Calc6 Integer, Color_Calc7 Integer,
               OrderSumm TVarChar, OrderTime TVarChar
               ) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderShedule());

   RETURN QUERY 
   WITH 
   tmpObject AS (SELECT Object_OrderShedule.Id                           AS Id
                      , Object_OrderShedule.ObjectCode                   AS Code
                      , ObjectLink_OrderShedule_Unit.ChildObjectId       AS UnitId 
                      , ObjectLink_OrderShedule_Contract.ChildObjectId   AS ContractId
                      , ObjectLink_Contract_Juridical.ChildObjectId      AS JuridicalId
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat AS Value1
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat AS Value2
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat AS Value3
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat AS Value4
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat AS Value5
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat AS Value6
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat AS Value7
        
                      , Object_OrderShedule.isErased     AS isErased
                 FROM Object AS Object_OrderShedule
                      INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                            ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                           AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                           AND (ObjectLink_OrderShedule_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                      LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                           ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                          AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                      INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                             ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_OrderShedule_Contract.ChildObjectId
                                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                            AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                 WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                  AND (Object_OrderShedule.isErased = inShowErased OR inShowErased = True OR inisShowAll = True)
                 )
   , tmpAll AS (SELECT Object_Unit.Id      AS UnitId
                     , Object_Contract.Id  AS ContractId
                     , ObjectLink_Contract_Juridical.ChildObjectId  AS JuridicalId
                FROM Object AS Object_Unit
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                          ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                         AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                     LEFT JOIN Object AS Object_Contract ON Object_Contract.DescId = zc_Object_Contract()
                     INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                           AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                WHERE Object_Unit.DescId = zc_Object_Unit()
                  AND (Object_Unit.Id = inUnitId OR inUnitId = 0)
                  AND ObjectLink_Unit_Parent.ChildObjectId is not  NULL
                  AND inisShowAll = True
                )

       SELECT 
             Object_OrderShedule.Id
           , Object_OrderShedule.Code
       
           , Object_OrderShedule.Value1 
           , Object_OrderShedule.Value2 
           , Object_OrderShedule.Value3 
           , Object_OrderShedule.Value4 
           , Object_OrderShedule.Value5 
           , Object_OrderShedule.Value6 
           , Object_OrderShedule.Value7 

           , Object_Unit_Juridical.ValueData      AS OurJuridicalName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName 
           
           , Object_ProvinceCity.Id               AS ProvinceCityId
           , Object_ProvinceCity.ValueData        AS ProvinceCityName
      
           , Object_Contract_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName 
                     
           , Object_OrderShedule.isErased         AS isErased

           , (CASE WHEN Object_OrderShedule.Value1 in (1,3) THEN '�����������,' ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value2 in (1,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value3 in (1,3) THEN '�����,'       ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value4 in (1,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value5 in (1,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value6 in (1,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value7 in (1,3) THEN '�����������'  ELSE '' END) ::TVarChar          AS Inf_Text1
           , (CASE WHEN Object_OrderShedule.Value1 in (2,3) THEN '�����������,' ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value2 in (2,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value3 in (2,3) THEN '�����,'       ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value4 in (2,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value5 in (2,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value6 in (2,3) THEN '�������,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value7 in (2,3) THEN '�����������'  ELSE '' END) ::TVarChar          AS Inf_Text2
           
           , CASE WHEN Object_OrderShedule.Value1 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value1 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value1 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc1
           , CASE WHEN Object_OrderShedule.Value2 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value2 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value2 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc2
           , CASE WHEN Object_OrderShedule.Value3 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value3 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value3 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc3
           , CASE WHEN Object_OrderShedule.Value4 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value4 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value4 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc4
           , CASE WHEN Object_OrderShedule.Value5 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value5 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value5 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc5
           , CASE WHEN Object_OrderShedule.Value6 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value6 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value6 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc6
           , CASE WHEN Object_OrderShedule.Value7 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value7 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value7 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc7

           , CASE WHEN COALESCE (ObjectFloat_OrderSumm_Contract.ValueData, 0) = 0 
                  THEN CASE WHEN COALESCE (ObjectFloat_OrderSumm.ValueData, 0) = 0 
                            THEN CASE WHEN COALESCE (ObjectString_OrderSumm_Contract.ValueData, '') <> '' 
                                      THEN ObjectString_OrderSumm_Contract.ValueData 
                                      ELSE COALESCE (ObjectString_OrderSumm.ValueData,'')
                                 END
                            ELSE CAST (ObjectFloat_OrderSumm.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm.ValueData,'')
                       END
                  ELSE CAST (ObjectFloat_OrderSumm_Contract.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm_Contract.ValueData,'')
             END                                            ::TVarChar AS OrderSumm

            /*CASE WHEN COALESCE (ObjectFloat_OrderSumm.ValueData,0) = 0 THEN COALESCE (ObjectString_OrderSumm.ValueData,'') 
                  ELSE CAST (ObjectFloat_OrderSumm.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm.ValueData,'')
             END                                            ::TVarChar AS OrderSumm 
             */
           , CASE WHEN COALESCE (ObjectString_OrderTime_Contract.ValueData,'')  <> ''  
                  THEN ObjectString_OrderTime_Contract.ValueData 
                  ELSE COALESCE (ObjectString_OrderTime.ValueData,'') 
             END ::TVarChar AS OrderTime

       FROM tmpObject AS Object_OrderShedule
           FULL JOIN tmpAll ON tmpAll.UnitId = Object_OrderShedule.UnitId
                           AND tmpAll.ContractId = Object_OrderShedule.ContractId  

           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = COALESCE (Object_OrderShedule.ContractId, tmpAll.ContractId)
           
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (Object_OrderShedule.UnitId, tmpAll.UnitId)

           LEFT JOIN Object AS Object_Contract_Juridical ON Object_Contract_Juridical.Id = COALESCE (Object_OrderShedule.JuridicalId, tmpAll.JuridicalId) 
          
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Unit_Juridical ON Object_Unit_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId       

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
        
            --
           LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                 ON ObjectFloat_OrderSumm.ObjectId = Object_Contract_Juridical.Id
                                AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Juridical_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderSumm
                                  ON ObjectString_OrderSumm.ObjectId = Object_Contract_Juridical.Id
                                 AND ObjectString_OrderSumm.DescId = zc_ObjectString_Juridical_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderTime
                                  ON ObjectString_OrderTime.ObjectId = Object_Contract_Juridical.Id
                                 AND ObjectString_OrderTime.DescId = zc_ObjectString_Juridical_OrderTime()
           --
           LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm_Contract
                                 ON ObjectFloat_OrderSumm_Contract.ObjectId = Object_Contract.Id
                                AND ObjectFloat_OrderSumm_Contract.DescId = zc_ObjectFloat_Contract_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderSumm_Contract 
                                  ON ObjectString_OrderSumm_Contract.ObjectId = Object_Contract.Id
                                 AND ObjectString_OrderSumm_Contract.DescId = zc_ObjectString_Contract_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderTime_Contract
                                  ON ObjectString_OrderTime_Contract.ObjectId = Object_Contract.Id
                                 AND ObjectString_OrderTime_Contract.DescId = zc_ObjectString_Contract_OrderTime()
 ;
  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.08.17         *
 22.06.17         *
 14.01.17         *
 05.10.16         * parce
 20.09.14         *

*/

-- ����
--select * from  gpSelect_Object_OrderShedule(inUnitId := 0 , inJuridicalId := 0 , inShowErased:= 'True'::Boolean, inisShowAll := 'True'::Boolean ,  inSession := '3'::TVarChar);