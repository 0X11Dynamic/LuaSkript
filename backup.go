package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type ASTNode struct {
	Opcode   string        `json:"OPCODE"`
	Variable string        `json:"Variable"`
	Scope    string        `json:"Scope"`
	Value    interface{}   `json:"Value,omitempty"`
	Values   []interface{} `json:"Values,omitempty"`
}

func parseScript(input string) []ASTNode {
	var nodes []ASTNode

	// Define regex pattern to match variables and tables
	pattern := `set\s*(\{[^}]*\})\s*to\s*(.*)`
	regex := regexp.MustCompile(pattern)
	matches := regex.FindAllStringSubmatch(input, -1)

	for _, match := range matches {
		varName := parseVariableName(match[1])
		value := match[2]

		// Determine if it's a table or a single variable
		if strings.HasSuffix(varName, "::*") {
			varName = strings.TrimSuffix(varName, "::*")
			node := ASTNode{
				Opcode:   "SETTABLE",
				Variable: varName,
				Scope:    getScope(varName),
				Values:   parseTableValues(value),
			}
			nodes = append(nodes, node)
		} else {
			node := ASTNode{
				Opcode:   "SETVAR",
				Variable: varName,
				Scope:    getScope(varName),
				Value:    parseValue(value),
			}
			nodes = append(nodes, node)
		}
	}

	return nodes
}

func parseVariableName(variable string) string {
	name := strings.Trim(variable, "{}")
	if strings.HasPrefix(name, "_") {
		name = name[1:]
	}
	return name
}

func getScope(varName string) string {
	if strings.HasPrefix(varName, "_") {
		return "local"
	}
	return "global"
}

func parseValue(value string) interface{} {
	value = strings.TrimSpace(value)
	if strings.HasPrefix(value, `"`) && strings.HasSuffix(value, `"`) {
		return value[1 : len(value)-1]
	}

	if num, err := strconv.Atoi(value); err == nil {
		return num
	}
	if floatNum, err := strconv.ParseFloat(value, 64); err == nil {
		return floatNum
	}
	if value == "true" || value == "false" {
		return value == "true"
	}

	return value
}

func parseTableValues(value string) []interface{} {
	value = strings.TrimSpace(value)
	if strings.HasPrefix(value, "{") && strings.HasSuffix(value, "}") {
		value = value[1 : len(value)-1]
	}

	var values []interface{}
	var currentValue strings.Builder
	nestingLevel := 0

	for _, char := range value {
		if char == '{' {
			nestingLevel++
			if nestingLevel == 1 {
				// When entering a new table, flush current value if not empty
				trimmedValue := strings.TrimSpace(currentValue.String())
				if trimmedValue != "" {
					values = append(values, parseValue(trimmedValue))
				}
				currentValue.Reset()
				continue
			}
		} else if char == '}' {
			nestingLevel--
			if nestingLevel == 0 {
				// When exiting a nested table, parse it as a subtable
				nestedTable := parseTableValues(currentValue.String())
				values = append(values, nestedTable)
				currentValue.Reset()
				continue
			}
		}

		if nestingLevel > 0 || char != ',' {
			// Accumulate characters if inside a nested table or if not a comma
			currentValue.WriteRune(char)
		} else {
			// At top level, comma separates values
			trimmedValue := strings.TrimSpace(currentValue.String())
			if trimmedValue != "" {
				values = append(values, parseValue(trimmedValue))
			}
			currentValue.Reset()
		}
	}

	// Add the last value if it's non-empty
	trimmedValue := strings.TrimSpace(currentValue.String())
	if trimmedValue != "" {
		values = append(values, parseValue(trimmedValue))
	}

	return values
}

func main() {
	inputFile := "input.sk"

	file, err := os.Open(inputFile)
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	var input strings.Builder
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		input.WriteString(scanner.Text() + "\n")
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
		return
	}

	ast := parseScript(input.String())
	astJSON, err := json.MarshalIndent(ast, "", "  ")
	if err != nil {
		fmt.Println("Error marshalling JSON:", err)
		return
	}

	err = os.WriteFile("output.json", astJSON, 0644)
	if err != nil {
		fmt.Println("Error writing file:", err)
		return
	}

	fmt.Println("AST has been written to output.json")
}
