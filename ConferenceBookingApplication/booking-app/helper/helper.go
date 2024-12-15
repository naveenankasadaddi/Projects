package helper

import "strings"

func ValidateInput(firstName string, lastName string, email string, userTickets int, remainingTickets int) (bool, bool, bool) {
	isValidName := len(firstName) > 2 && len(lastName) > 2
	isValidemail := strings.Contains(email, "@")
	isValiduserticket := userTickets > 0 && userTickets <= remainingTickets

	return isValidName, isValidemail, isValiduserticket
}
