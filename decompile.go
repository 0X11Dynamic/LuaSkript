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
	Variable string        `json:"Variable,omitempty"`
	Scope    string        `json:"Scope,omitempty"`
	Value    interface{}   `json:"Value,omitempty"`
	Values   []interface{} `json:"Values,omitempty"`
	Args     []string      `json:"Args,omitempty"`
	Body     []ASTNode     `json:"Body,omitempty"`
}

func parseScript(input string) []ASTNode {
	var nodes []ASTNode

	varPatterns := `set\s*(\{[^}]*\})\s*to\s*(.*)`
	funcPattern := `function\s*(\w+)\s*\(([^)]*)\)\s*\{([^}]*)\}`

	varRegex := regexp.MustCompile(varPatterns)
	funcRegex := regexp.MustCompile(funcPattern)

	matches := varRegex.FindAllStringSubmatch(input, -1)
	for _, match := range matches {
		nodes = append(nodes, createASTNode(match))
	}

	funcMatches := funcRegex.FindAllStringSubmatch(input, -1)
	for _, match := range funcMatches {
		funcNode := ASTNode{
			Opcode:   "SETFUNC",
			Variable: match[1],
			Scope:    "local",
			Args:     parseFunctionArgs(match[2]),
			Body:     parseFunctionBody(match[3]),
		}
		nodes = append(nodes, funcNode)
	}

	return nodes
}

func createASTNode(match []string) ASTNode {
	varName := parseVariableName(match[1])
	value := match[2]

	if strings.HasSuffix(varName, "::*") {
		varName = strings.TrimSuffix(varName, "::*")
		return ASTNode{
			Opcode:   "SETTABLE",
			Variable: varName,
			Scope:    getScope(varName),
			Values:   parseTableValues(value),
		}
	} else {
		return ASTNode{
			Opcode:   "SETVAR",
			Variable: varName,
			Scope:    getScope(varName),
			Value:    parseValue(value),
		}
	}
}

func parseFunctionArgs(args string) []string {
	argList := strings.Split(args, ",")
	for i, arg := range argList {
		argList[i] = strings.TrimSpace(arg)
	}
	return argList
}

func parseFunctionBody(body string) []ASTNode {
	body = strings.TrimSpace(body)
	lines := strings.Split(body, "\n")
	var nodes []ASTNode
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		if strings.HasPrefix(line, "print") {
			node := ASTNode{
				Opcode: "CALLFUNC",
				Value:  "print",
				Values: parsePrintArgs(line),
			}
			nodes = append(nodes, node)
		}
	}
	return nodes
}

func parsePrintArgs(line string) []interface{} {
	args := strings.TrimPrefix(line, "print(")
	args = strings.TrimSuffix(args, ")")
	return parseTableValues(args)
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
				nestedTable := parseTableValues(currentValue.String())
				values = append(values, nestedTable)
				currentValue.Reset()
				continue
			}
		}

		if nestingLevel > 0 || char != ',' {
			currentValue.WriteRune(char)
		} else {
			trimmedValue := strings.TrimSpace(currentValue.String())
			if trimmedValue != "" {
				values = append(values, parseValue(trimmedValue))
			}
			currentValue.Reset()
		}
	}

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
