import React from "react";
import { StyleSheet, TextInput, Text, View, Button, Image } from "react-native";
import { Appbar } from "react-native-paper";

export default function App() {
  return (
    <View style={styles.container}>
      <Appbar style={styles.bottom}>
        <Appbar.Content title="Our app" />
      </Appbar>
      <Image
        style={{ width: 128, height: 128 }}
        source={require("./assets/icon.png")}
      ></Image>
      <View style={styles.buttonContainer}>
        <Button title="button"></Button>
        <Button title="button"></Button>
      </View>
      <View style={styles.buttonContainer}>
        <Button title="button"></Button>
        <Button title="button"></Button>
      </View>
      <View style={{ display: "flex", flexDirection: "row" }}>
        <Text>Email</Text>
        <TextInput
          style={{ backgroundColor: "#ededed", height: 40, width: 200 }}
          value={"Hello"}
        ></TextInput>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: "100%",
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center"
  },

  buttonContainer: {
    display: "flex",
    flexDirection: "row",
    width: "100%",
    justifyContent: "space-evenly",
    margin: 30
  },

  bottom: {
    position: "absolute",
    left: 0,
    right: 0,
    top: 0
  }
});
