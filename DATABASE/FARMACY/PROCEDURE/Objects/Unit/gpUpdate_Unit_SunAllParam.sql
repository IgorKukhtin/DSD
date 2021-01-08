-- Function: gpUpdate_Unit_SunAllParam()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SunAllParam(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SunAllParam(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inUnnitFrom           Integer   ,    -- Подразделение источник
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 OR COALESCE(inUnnitFrom, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM

        lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN(), inId, COALESCE (ObjectString_ListDaySUN.ValueData, ''))
      , lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN_pi(), inId, COALESCE (ObjectString_ListDaySUN_pi.ValueData, ''))

      , lpInsertUpdate_ObjectString(zc_ObjectString_Unit_SUN_v1_Lock(), inId, COALESCE (ObjectString_SUN_v1_Lock.ValueData, ''))
      , lpInsertUpdate_ObjectString(zc_ObjectString_Unit_SUN_v2_Lock(), inId, COALESCE (ObjectString_SUN_v2_Lock.ValueData, ''))
      , lpInsertUpdate_ObjectString(zc_ObjectString_Unit_SUN_v4_Lock(), inId, COALESCE (ObjectString_SUN_v4_Lock.ValueData, ''))
                 
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffInSUN(), inId, COALESCE (ObjectFloat_KoeffInSUN.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffOutSUN(), inId, COALESCE (ObjectFloat_KoeffOutSUN.ValueData,0))

      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffInSUN_v3(), inId, COALESCE (ObjectFloat_KoeffInSUN_v3.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffOutSUN_v3(), inId, COALESCE (ObjectFloat_KoeffOutSUN_v3.ValueData,0))
      
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T1_SUN_v2(), inId, COALESCE (ObjectFloat_T1_SUN_v2.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T2_SUN_v2(), inId, COALESCE (ObjectFloat_T2_SUN_v2.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T1_SUN_v4(), inId, COALESCE (ObjectFloat_T1_SUN_v4.ValueData,0))
      
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_SunIncome(), inId, COALESCE (ObjectFloat_SunIncome.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Sun_v2Income(), inId, COALESCE (ObjectFloat_Sun_v2Income.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Sun_v4Income(), inId, COALESCE (ObjectFloat_Sun_v4Income.ValueData,0))

      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_v1(), inId, COALESCE (ObjectFloat_HT_SUN_v1.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_v2(), inId, COALESCE (ObjectFloat_HT_SUN_v2.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_v4(), inId, COALESCE (ObjectFloat_HT_SUN_v4.ValueData,0))
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_HT_SUN_All(), inId, COALESCE (ObjectFloat_HT_SUN_All.ValueData,0))
      
      , lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_LimitSUN_N(), inId, COALESCE (ObjectFloat_LimitSUN_N.ValueData,0))

      , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_DeySupplSun1(), inId, COALESCE (ObjectFloat_DeySupplSun1.ValueData,0))
      , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_MonthSupplSun1(), inId, COALESCE (ObjectFloat_MonthSupplSun1.ValueData,0))

      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN(), inId, COALESCE (ObjectBoolean_SUN.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2(), inId, COALESCE (ObjectBoolean_SUN_v2.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v3(), inId, COALESCE (ObjectBoolean_SUN_v3.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_in(), inId, COALESCE (ObjectBoolean_SUN_in.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_out(), inId, COALESCE (ObjectBoolean_SUN_out.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_Supplement_in(), inId, COALESCE (ObjectBoolean_SUN_Supplement_in.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_Supplement_out(), inId, COALESCE (ObjectBoolean_SUN_Supplement_out.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_in(), inId, COALESCE (ObjectBoolean_SUN_v2_in.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_out(), inId, COALESCE (ObjectBoolean_SUN_v2_out.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v3_in(), inId, COALESCE (ObjectBoolean_SUN_v3_in.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v3_out(), inId, COALESCE (ObjectBoolean_SUN_v3_out.ValueData, FALSE))
      
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v4(), inId, COALESCE (ObjectBoolean_SUN_v4.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v4_in(), inId, COALESCE (ObjectBoolean_SUN_v4_in.ValueData, FALSE))
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v4_out(), inId, COALESCE (ObjectBoolean_SUN_v4_out.ValueData, FALSE))
      
      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_LockSale(), inId, COALESCE (ObjectBoolean_SUN_v2_LockSale.ValueData, FALSE))

      , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_NotSold(), inId, COALESCE (ObjectBoolean_SUN_NotSold.ValueData, FALSE))


    FROM Object AS Object_Unit

        LEFT JOIN ObjectString AS ObjectString_ListDaySUN
                               ON ObjectString_ListDaySUN.ObjectId = Object_Unit.Id 
                              AND ObjectString_ListDaySUN.DescId = zc_ObjectString_Unit_ListDaySUN()

        LEFT JOIN ObjectString AS ObjectString_ListDaySUN_pi
                               ON ObjectString_ListDaySUN_pi.ObjectId = Object_Unit.Id 
                              AND ObjectString_ListDaySUN_pi.DescId = zc_ObjectString_Unit_ListDaySUN_pi()

        LEFT JOIN ObjectString AS ObjectString_SUN_v1_Lock
                               ON ObjectString_SUN_v1_Lock.ObjectId = Object_Unit.Id 
                              AND ObjectString_SUN_v1_Lock.DescId = zc_ObjectString_Unit_SUN_v1_Lock()
        LEFT JOIN ObjectString AS ObjectString_SUN_v2_Lock
                               ON ObjectString_SUN_v2_Lock.ObjectId = Object_Unit.Id 
                              AND ObjectString_SUN_v2_Lock.DescId = zc_ObjectString_Unit_SUN_v2_Lock()
        LEFT JOIN ObjectString AS ObjectString_SUN_v4_Lock
                               ON ObjectString_SUN_v4_Lock.ObjectId = Object_Unit.Id 
                              AND ObjectString_SUN_v4_Lock.DescId = zc_ObjectString_Unit_SUN_v4_Lock()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN
                                ON ObjectBoolean_SUN.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2
                                ON ObjectBoolean_SUN_v2.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2.DescId = zc_ObjectBoolean_Unit_SUN_v2()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v3
                                ON ObjectBoolean_SUN_v3.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v3.DescId = zc_ObjectBoolean_Unit_SUN_v3()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_in
                                ON ObjectBoolean_SUN_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_in.DescId = zc_ObjectBoolean_Unit_SUN_in()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_out
                                ON ObjectBoolean_SUN_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_out.DescId = zc_ObjectBoolean_Unit_SUN_out()
                               
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_in
                                ON ObjectBoolean_SUN_Supplement_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_Supplement_in.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_in()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_out
                                ON ObjectBoolean_SUN_Supplement_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_Supplement_out.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_out()
                               
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_in
                                ON ObjectBoolean_SUN_v2_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2_in.DescId = zc_ObjectBoolean_Unit_SUN_v2_in()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_out
                                ON ObjectBoolean_SUN_v2_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2_out.DescId = zc_ObjectBoolean_Unit_SUN_v2_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v3_in
                                ON ObjectBoolean_SUN_v3_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v3_in.DescId = zc_ObjectBoolean_Unit_SUN_v3_in()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v3_out
                                ON ObjectBoolean_SUN_v3_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v3_out.DescId = zc_ObjectBoolean_Unit_SUN_v3_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v4
                                ON ObjectBoolean_SUN_v4.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v4.DescId = zc_ObjectBoolean_Unit_SUN_v4()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v4_in
                                ON ObjectBoolean_SUN_v4_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v4_in.DescId = zc_ObjectBoolean_Unit_SUN_v4_in()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v4_out
                                ON ObjectBoolean_SUN_v4_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v4_out.DescId = zc_ObjectBoolean_Unit_SUN_v4_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_NotSold
                                ON ObjectBoolean_SUN_NotSold.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_NotSold.DescId = zc_ObjectBoolean_Unit_SUN_NotSold()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_LockSale
                                ON ObjectBoolean_SUN_v2_LockSale.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2_LockSale.DescId = zc_ObjectBoolean_Unit_SUN_v2_LockSale()

        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffInSUN
                              ON ObjectFloat_KoeffInSUN.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffInSUN.DescId = zc_ObjectFloat_Unit_KoeffInSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffOutSUN
                              ON ObjectFloat_KoeffOutSUN.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN()

        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffInSUN_v3
                              ON ObjectFloat_KoeffInSUN_v3.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffInSUN_v3.DescId = zc_ObjectFloat_Unit_KoeffInSUN_v3()
        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffOutSUN_v3
                              ON ObjectFloat_KoeffOutSUN_v3.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffOutSUN_v3.DescId = zc_ObjectFloat_Unit_KoeffOutSUN_v3()

        LEFT JOIN ObjectFloat AS ObjectFloat_T1_SUN_v2
                              ON ObjectFloat_T1_SUN_v2.ObjectId = Object_Unit.Id
                             AND ObjectFloat_T1_SUN_v2.DescId = zc_ObjectFloat_Unit_T1_SUN_v2()
        LEFT JOIN ObjectFloat AS ObjectFloat_T2_SUN_v2
                              ON ObjectFloat_T2_SUN_v2.ObjectId = Object_Unit.Id
                             AND ObjectFloat_T2_SUN_v2.DescId = zc_ObjectFloat_Unit_T2_SUN_v2()
        LEFT JOIN ObjectFloat AS ObjectFloat_T1_SUN_v4
                              ON ObjectFloat_T1_SUN_v4.ObjectId = Object_Unit.Id
                             AND ObjectFloat_T1_SUN_v4.DescId = zc_ObjectFloat_Unit_T1_SUN_v4()

        LEFT JOIN ObjectFloat AS ObjectFloat_SunIncome
                              ON ObjectFloat_SunIncome.ObjectId = Object_Unit.Id
                             AND ObjectFloat_SunIncome.DescId = zc_ObjectFloat_Unit_SunIncome()
        LEFT JOIN ObjectFloat AS ObjectFloat_Sun_v2Income
                              ON ObjectFloat_Sun_v2Income.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Sun_v2Income.DescId = zc_ObjectFloat_Unit_Sun_v2Income()
        LEFT JOIN ObjectFloat AS ObjectFloat_Sun_v4Income
                              ON ObjectFloat_Sun_v4Income.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Sun_v4Income.DescId = zc_ObjectFloat_Unit_Sun_v4Income()

        LEFT JOIN ObjectFloat AS ObjectFloat_HT_SUN_v1
                              ON ObjectFloat_HT_SUN_v1.ObjectId = Object_Unit.Id
                             AND ObjectFloat_HT_SUN_v1.DescId = zc_ObjectFloat_Unit_HT_SUN_v1()
        LEFT JOIN ObjectFloat AS ObjectFloat_HT_SUN_v2
                              ON ObjectFloat_HT_SUN_v2.ObjectId = Object_Unit.Id
                             AND ObjectFloat_HT_SUN_v2.DescId = zc_ObjectFloat_Unit_HT_SUN_v2()
        LEFT JOIN ObjectFloat AS ObjectFloat_HT_SUN_v4
                              ON ObjectFloat_HT_SUN_v4.ObjectId = Object_Unit.Id
                             AND ObjectFloat_HT_SUN_v4.DescId = zc_ObjectFloat_Unit_HT_SUN_v4()
        LEFT JOIN ObjectFloat AS ObjectFloat_HT_SUN_All
                              ON ObjectFloat_HT_SUN_All.ObjectId = Object_Unit.Id
                             AND ObjectFloat_HT_SUN_All.DescId = zc_ObjectFloat_Unit_HT_SUN_All()

        LEFT JOIN ObjectFloat AS ObjectFloat_LimitSUN_N
                              ON ObjectFloat_LimitSUN_N.ObjectId = Object_Unit.Id
                             AND ObjectFloat_LimitSUN_N.DescId = zc_ObjectFloat_Unit_LimitSUN_N()

        LEFT JOIN ObjectFloat AS ObjectFloat_DeySupplSun1
                              ON ObjectFloat_DeySupplSun1.ObjectId = Object_Unit.Id
                             AND ObjectFloat_DeySupplSun1.DescId = zc_ObjectFloat_Unit_DeySupplSun1()
        LEFT JOIN ObjectFloat AS ObjectFloat_MonthSupplSun1
                              ON ObjectFloat_MonthSupplSun1.ObjectId = Object_Unit.Id
                             AND ObjectFloat_MonthSupplSun1.DescId = zc_ObjectFloat_Unit_MonthSupplSun1()

        LEFT JOIN ObjectFloat AS ObjectFloat_PercentSAUA
                              ON ObjectFloat_PercentSAUA.ObjectId = Object_Unit.Id
                             AND ObjectFloat_PercentSAUA.DescId = zc_ObjectFloat_Unit_PercentSAUA()


    WHERE Object_Unit.Id = inUnnitFrom;

    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.01.21                                                       *
*/

-- select * from gpUpdate_Unit_SunAllParam(inId := 16001195 , inUnnitFrom := 183292 ,  inSession := '3');