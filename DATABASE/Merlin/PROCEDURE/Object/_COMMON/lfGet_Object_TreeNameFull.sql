-- Function: lfGet_Object_TreeNameFull (Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_Object_TreeNameFull (Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_TreeNameFull (
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
                               ELSE lfGet_Object_TreeNameFull (Objectlink.ChildObjectId, inObjectLinkDescId) || ' '
                          END
                       || Object.ValueData
                          
                   FROM Object
                        LEFT JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                                            AND ObjectLink.DescId   = inObjectLinkDescId
                        -- ������ �����, ��� ���������� ������
                        LEFT JOIN ObjectLink AS ObjectLink_parent
                                             ON ObjectLink_parent.ObjectId = Objectlink.ChildObjectId
                                            AND ObjectLink_parent.DescId   = inObjectLinkDescId
                        -- LEFT JOIN ObjectLink AS ObjectLink_Parent0 ON ObjectLink_Parent0.ObjectId = Objectlink.ChildObjectId
                        --                                           AND ObjectLink_Parent0.DescId = inObjectLinkDescId
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
 13.01.14                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_TreeNameFull (1946, zc_ObjectLink_GoodsGroup_Parent())
