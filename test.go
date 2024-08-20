package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

// Variable represents a variable with its name and type.
type Variable struct {
	Name string `json:"name"`
	Type string `json:"type,omitempty"`
}

// ASTNode represents a node in the Abstract Syntax Tree (AST).
type ASTNode struct {
	Type       string      `json:"type"`
	Value      interface{} `json:"value,omitempty"`
	Variable   *Variable   `json:"variable,omitempty"`
	Body       []*ASTNode  `json:"body,omitempty"` // Use pointer to ASTNode
	Name       string      `json:"name,omitempty"`
	Parameters []string    `json:"parameters,omitempty"`
	Arguments  []*ASTNode  `json:"arguments,omitempty"` // Use pointer to ASTNode
	Condition  *ASTNode    `json:"condition,omitempty"` // Use pointer to ASTNode
}

// parseLine parses a line of code and returns an ASTNode.
func parseLine(line string) *ASTNode {
	// Remove curly braces and trim whitespace
	line = strings.ReplaceAll(line, "{", "")
	line = strings.ReplaceAll(line, "}", "")
	line = strings.TrimSpace(line)

	if strings.HasPrefix(line, "set") {
		// Remove "set" and trim the line
		line = strings.TrimPrefix(line, "set")
		line = strings.TrimSpace(line)

		// Split the line by "to"
		parts := strings.Split(line, "to")
		if len(parts) != 2 {
			fmt.Println("Invalid 'set' statement:", line)
			return nil
		}

		// Trim each part
		varName := strings.TrimSpace(parts[0])
		varValue := strings.TrimSpace(parts[1])

		// Remove surrounding double quotes if they exist
		if strings.HasPrefix(varValue, `"`) && strings.HasSuffix(varValue, `"`) {
			varValue = varValue[1 : len(varValue)-1]
		}

		// Try to parse varValue as an integer
		var numericValue interface{}
		if num, err := strconv.Atoi(varValue); err == nil {
			numericValue = num
		} else {
			numericValue = varValue
		}

		// Create and return ASTNode for the 'set' statement
		return &ASTNode{
			Type:     "SETVAR",
			Variable: &Variable{Name: varName},
			Value:    numericValue,
		}
	}

	// Handle other types of lines if needed
	return nil
}

// AddNodeToAST adds an ASTNode to a slice of ASTNodes.
func AddNodeToAST(ast []*ASTNode, node *ASTNode) []*ASTNode {
	if node != nil {
		ast = append(ast, node)
	}
	return ast
}

// ConvertASTToLua converts an AST to Lua table syntax.
func ConvertASTToLua(ast []*ASTNode) string {
	var builder strings.Builder

	builder.WriteString("local ast = {\n")

	for i, node := range ast {
		if i > 0 {
			builder.WriteString(",\n")
		}
		builder.WriteString("  {\n")
		builder.WriteString(fmt.Sprintf("    type = \"%s\",\n", node.Type))

		if node.Variable != nil {
			builder.WriteString(fmt.Sprintf("    variable = { name = \"%s\" },\n", node.Variable.Name))
		}

		if node.Value != nil {
			switch v := node.Value.(type) {
			case string:
				builder.WriteString(fmt.Sprintf("    value = \"%s\",\n", v))
			case int:
				builder.WriteString(fmt.Sprintf("    value = %d,\n", v))
			}
		}

		builder.WriteString("  }")
	}

	builder.WriteString("\n}")

	return builder.String()
}

func main() {
	code := `
    set {StringVar} to "variable1"
	set {NUmVar} to 1
	`

	// Initialize AST slice
	var ast []*ASTNode

	// Split the string into lines
	lines := strings.Split(code, "\n")

	// Trim leading and trailing whitespace from each line and process
	for _, line := range lines {
		if strings.TrimSpace(line) != "" { // Skip empty lines
			node := parseLine(strings.TrimSpace(line))
			ast = AddNodeToAST(ast, node)
		}
	}

	// Convert AST to Lua table syntax
	luaTable := ConvertASTToLua(ast)

	// Print the Lua table
	fmt.Println(luaTable)

	// Optionally, save the Lua table to a file
	err := os.WriteFile("output.lua", []byte(luaTable), 0644)
	if err != nil {
		fmt.Println("Error writing Lua table to file:", err)
		return
	}
	fmt.Println("Lua table has been saved to output.lua")
}
