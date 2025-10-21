-- View: _bi_Guide_MovementDesc_View

 DROP VIEW IF EXISTS _bi_Guide_MovementDesc_View;

-- ���������� ��� ���������
/*
Id
Name
*/


CREATE OR REPLACE VIEW _bi_Guide_MovementDesc_View
AS
     SELECT
            MovementDesc.Id         AS Id
          , MovementDesc.ItemName   AS Name
     FROM MovementDesc
    ;

ALTER TABLE _bi_Guide_MovementDesc_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_MovementDesc_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_MovementDesc_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.10.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_MovementDesc_View
