
-- drop TABLE Object_Article

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_Article(
   Article             TVarChar NOT NULL PRIMARY KEY, 
   LastValue           Integer  NOT NULL 
  );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_Article_Article ON Object_Article (Article);

/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
20.11.22                                         *
*/
