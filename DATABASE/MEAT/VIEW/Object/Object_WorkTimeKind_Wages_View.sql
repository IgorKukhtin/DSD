-- View: Object_WorkTimeKind_Wages_View

-- DROP VIEW IF EXISTS Object_WorkTimeKind_Wages_View;

CREATE OR REPLACE VIEW Object_WorkTimeKind_Wages_View AS
    SELECT Object.Id
         , Object.ObjectCode
         , Object.ValueData
         , ObjectFloat_Tax.ValueData AS Tax
    FROM Object
         LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                               ON ObjectFloat_Tax.ObjectId = Object.Id
                              AND ObjectFloat_Tax.DescId   = zc_ObjectFloat_WorkTimeKind_Tax()
    WHERE Object.DescId = zc_Object_WorkTimeKind()
      AND Object.Id NOT IN (zc_Enum_WorkTimeKind_Holiday()    -- ������
                          , zc_Enum_WorkTimeKind_Hospital()   -- ����������
                          , zc_Enum_WorkTimeKind_Skip()       -- ������
                          , zc_Enum_WorkTimeKind_Trainee()    -- ������
                          , zc_Enum_WorkTimeKind_DayOff()     -- ��������
                           );
      /*AND Object.Id IN (zc_Enum_WorkTimeKind_Work()       -- ������� ����
                      , zc_Enum_WorkTimeKind_Trainee50()  -- ������50%+
                      , zc_Enum_WorkTimeKind_Trainee()    -- ����������+
                      , zc_Enum_WorkTimeKind_Trial()      -- ������� �����+
                       );*/
        
ALTER TABLE Object_WorkTimeKind_Wages_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 24.03.16                                        *
 09.11.15                                                         *
*/

-- ����
-- SELECT * FROM Object_WorkTimeKind_Wages_View
