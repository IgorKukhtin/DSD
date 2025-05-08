-- View: _bi_Guide_JuridicalGroup_View

DROP VIEW IF EXISTS _bi_Guide_JuridicalGroup_View;

--���������� ������ ����������� ���
CREATE OR REPLACE VIEW _bi_Guide_JuridicalGroup_View
AS
     SELECT 
            Object_JuridicalGroup.Id         AS Id 
          , Object_JuridicalGroup.ObjectCode AS Code
          , Object_JuridicalGroup.ValueData  AS Name
            -- ������� "������ ��/���"
          , Object_JuridicalGroup.isErased   AS isErased

            -- �������� ������
          , Object_Parent.Id                    AS ParentId 
          , Object_Parent.ObjectCode            AS ParentCode
          , Object_Parent.ValueData             AS ParentName

     FROM Object AS Object_JuridicalGroup
          -- �������� ������
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                               ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object_JuridicalGroup.Id
                              AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
          LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_JuridicalGroup_Parent.ChildObjectId
                
     WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
    ;
     
ALTER TABLE _bi_Guide_JuridicalGroup_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.25         *
*/

-- ����
-- SELECT * FROM _bi_Guide_JuridicalGroup_View
