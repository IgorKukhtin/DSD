-- View: Object_WorkTimeKind_Wages_View

-- DROP VIEW IF EXISTS Object_WorkTimeKind_Wages_View;

CREATE OR REPLACE VIEW Object_WorkTimeKind_Wages_View AS
    SELECT Object.Id
         , Object.ObjectCode
         , Object.ValueData
    FROM Object
    WHERE Object.DescId = zc_Object_WorkTimeKind()
      AND Object.Id IN (zc_Enum_WorkTimeKind_Work()       -- ������� ����
                      , zc_Enum_WorkTimeKind_Trainee50()  -- ������50%+
                      , zc_Enum_WorkTimeKind_Trainee()    -- ����������+
                      , zc_Enum_WorkTimeKind_Trial()      -- ������� �����+
                      -- , zc_Enum_WorkTimeKind_Holiday()    -- ������
                       );

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
