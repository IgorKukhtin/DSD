INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Juridical(), 'zc_ObjectBoolean_Juridical_isCorporate', 'Признак наша ли собственность это юридическое лицо' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Juridical_isCorporate');  
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProfitLoss(), 'zc_ObjectBoolean_ProfitLoss_onComplete', 'признак Создан при проведении' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_ProfitLoss_onComplete');  
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_Account(), 'zc_ObjectBoolean_Account_onComplete', 'признак Создан при проведении' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_Account_onComplete');  
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT NULL, 'zc_ObjectBoolean_isLeaf', 'признак есть ли потом у дерева' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_isLeaf');  

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13                                        * НОВАЯ СХЕМА
 08.07.13                         *  zc_ObjectBoolean_isLeaf
*/
