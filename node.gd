@tool
extends Node

@export_custom(PROPERTY_HINT_EXPRESSION,"TESSSt") var enter_expression_here:String
@export_tool_button("Run Expression") var run_expression = hello

func hello():
	var expression: Expression = Expression.new()
	if expression.parse(enter_expression_here) != OK:
		prints("Expression parse error:\n\t",expression.get_error_text())
	var result = expression.execute()
	if expression.has_execute_failed():
		prints("Expression failed:",expression.get_error_text())
	else:
		print("Expression result: ",result)
