-- View: _bi_Guide_Unit_View

 DROP VIEW IF EXISTS _bi_Guide_Unit_View;

-- ���������� �������������
CREATE OR REPLACE VIEW _bi_Guide_Unit_View
AS
       SELECT
             Object_Unit.Id         AS Id
           , Object_Unit.ObjectCode AS Code
           , Object_Unit.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_Unit.isErased   AS isErased

            -- �������� ������
          , Object_Parent.Id                    AS ParentId 
          , Object_Parent.ObjectCode            AS ParentCode
          , Object_Parent.ValueData             AS ParentName

       FROM Object AS Object_Unit
            -- �������� ������
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

       WHERE Object_Unit.DescId = zc_Object_Unit()
      ;

ALTER TABLE _bi_Guide_Unit_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_Unit_View
