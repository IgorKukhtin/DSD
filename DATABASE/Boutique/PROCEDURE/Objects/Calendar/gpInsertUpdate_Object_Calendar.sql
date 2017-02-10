-- Function: lpInsertUpdate_Object_Calendar(Integer, Boolean, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Calendar(Integer, TDateTime, TDateTime, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Calendar( TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Calendar(
   -- IN inId                Integer   , -- ���� ������� <��������� ������� ����>
    IN inStartDate         TDateTime , -- ���� ������
    IN inEndDate           TDateTime , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer AS   --void
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    perform lpInsertUpdate_Object_Calendar (ioId := 0, inWorking := tmpCalendar.iswork, inValue := tmpCalendar.OperDate, inUserId := '2')
      -- 
     from( select OperDate, case when date_part('isodow',OperDate) in (6,7) then false else true end as iswork
      FROM  
       (SELECT generate_series(inStartDate, inEndDate, '1 day'::interval) as OperDate) AS Period 
       left join (SELECT 
           Object_Calendar.Id         AS Id
  
         , ObjectBoolean_Working.ValueData     AS Working  
         
         , ObjectDate_Value.ValueData      AS Value
                                                        
         , Object_Calendar.isErased AS isErased
         
     FROM ObjectDate AS ObjectDate_Period
      
          LEFT JOIN ObjectDate AS ObjectDate_Value
                               ON ObjectDate_Value.ObjectId = ObjectDate_Period.ObjectId
                              AND ObjectDate_Value.DescId = zc_ObjectDate_Calendar_Value()
                              
          LEFT JOIN Object AS Object_Calendar ON Object_Calendar.Id = ObjectDate_Value.ObjectId
         
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Working 
                                ON ObjectBoolean_Working.ObjectId = Object_Calendar.Id 
                               AND ObjectBoolean_Working.DescId = zc_ObjectBoolean_Calendar_Working()
          
     WHERE ObjectDate_period.ValueData BETWEEN inStartDate AND inEndDate
       AND Object_Calendar.DescId = zc_Object_Calendar()

       ) as Object_find on Value =  Period.OperDate

        where Object_find.Value  is null) as tmpCalendar
     ;   
   
   
   -- ��������� ��������
   return 0;
   --PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Calendar (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.11.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Calendar ('12.11.2013', '12.12.2013', '2')