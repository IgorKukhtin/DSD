-- Function: lfGet_Object_BuildingName (Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_Object_BuildingName (Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_BuildingName (
 inObjectId               Integer,    -- ��������� ��-�� ������
 inObjectLinkDescId       Integer     -- ���� ������
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbNameFull TVarChar;
BEGIN
     vbNameFull:= (SELECT CASE WHEN COALESCE (ObjectLink.ChildObjectId, 0) = 0
                                    THEN ''
                               -- ������ �����, ��� ���������� ������
                               WHEN inObjectLinkDescId = zc_ObjectLink_Unit_Parent()
                                AND ObjectLink_parent.ChildObjectId IS NULL
                                    THEN ''
                               ELSE lfGet_Object_TreeNameFull (ObjectLink_parent.ChildObjectId, inObjectLinkDescId)
                          END
                      
                   FROM Object
                        LEFT JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                                            AND ObjectLink.DescId   = inObjectLinkDescId
                        -- ������ �����, ��� ���������� ������
                        LEFT JOIN ObjectLink AS ObjectLink_parent
                                             ON ObjectLink_parent.ObjectId = Objectlink.ChildObjectId
                                            AND ObjectLink_parent.DescId   = inObjectLinkDescId
                   WHERE Object.Id = inObjectId
                  );
     --
     RETURN (vbNameFull);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.05.22         *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_BuildingName (52693, zc_ObjectLink_Unit_Parent())
