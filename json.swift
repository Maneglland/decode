class ResponseData: ObservableObject{
    @Published var result: [Result] = []
    func API()-> Bool{
        guard let url = URL(string: "http://text-processing.com/api/sentiment/") else { fatalError("Missing URL") }
        var request = URLRequest(url: url)
        request.setValue("text=great", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                guard let data = data else { return }
                DispatchQueue.main.async {
                do {
                    let decodedResult = try JSONDecoder().decode(Result.self, from: data)
                    self.result = [decodedResult]
                    print(self.result)
                        } catch let error {
                            print("Error decoding: ", error)
                    }
                }
            }
        })

        dataTask.resume()
        return true
    }
}
