/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

// kBotCmd represents the kBot command
var kBotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("\nPlease check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload

			if strings.HasPrefix(m.Text(), "echo") {
				err = m.Send(fmt.Sprintf("You said: %s", strings.TrimPrefix(m.Text(), "echo")))

			} else {
				switch payload {
				case "hello":
					err = m.Send(fmt.Sprintf("Hello I'm Kbot %s!", appVersion))

				case "help":
					err = m.Send(fmt.Sprintf("Here are the available commands for Kbot %s:\n/start - Start the bot\n/start hello - Say hi to Kbot\necho - Repeat whatever you say\n/start help - Display this help message", appVersion))

				default:
					err = m.Send(fmt.Sprintf("Hello! Welcome to Kbot %s!", appVersion))
				}
			}

			return err
		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kBotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kBotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kBotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
