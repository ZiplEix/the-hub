
export const load = ({ params, fetch }) => {
    const fetchSub = async (id) => {
        const res = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}`)
        const data = await res.json()
        console.log(data);
        return data
    }

    const fetchComments = async (id) => {
        const res = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}/comments`)
        const data = await res.json()
        data.sort((a, b) => b.id - a.id);
        console.log(data);
        return data
    }

    return {
        sub: fetchSub(params.subId),
        comments: fetchComments(params.subId)
    }
}
